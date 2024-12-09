with jsn as (
    select page, table_name, table_cn, unnest(columns, recursive:=true),
        generate_subscripts(columns, 1) as r
    from "D:\misc\minmetals\人力资源\数据建模\干部监督.json"),
fix as (
    select   -- 增加固定列
        page,
        table_name, 
        table_cn,
        unnest([
    {'column_name': 'org_cd',       'column_cn': '组织机构代码',  'data_type': 'VARCHAR(255)', 'r': 101},
    {'column_name': 'org_cn_abbr',  'column_cn': '组织机构简称',  'data_type': 'VARCHAR(255)', 'r': 102},
    {'column_name': 'biz_date',     'column_cn': '业务日期',      'data_type': 'VARCHAR(8)', 'r': 103}], recursive:=true)
    from (select distinct page, table_name, table_cn from jsn)),
col as (
    from jsn
    union all by name
    from fix
    where (page, table_name, column_name) not in 
        (select struct_pack(page, table_name, column_name) from jsn)),
tab as (
    select page, table_name, any_value(table_cn) as table_cn,
        string_agg(format('`{}`', column_name) order by r) filter (key) as key_list,
        string_agg(format('    `{}` {} {} comment ''{}''',
            column_name,
            coalesce(data_type, 'VARCHAR(255)'),
            if(key, 'not null', 'null'),
            case column_name
                when 'org_cd' then '组织机构代码' 
                when 'org_cn_abbr' then '组织机构简称'
                when 'biz_date' then '业务日期'
                else column_cn
            end), ',
' order by r) as column_list
    from col
    group by page, table_name)
-- ADS 表字段信息
--select
--    table_name as 表英文名称,
--    table_cn as 表中文名称,
--    column_name as 字段英文名称,
--    column_cn as 字段中文名称,
--    coalesce(unit, '') as 单位,
--    coalesce(description, '') as 字段说明,
--    data_type as 字段类型,
--    if(key, '是', '否') as 是否主键
--from col
--order by table_name, r        
select 
    page as 页面,
    '每日' as 频率,
    table_name as 表英文名称,
    table_cn as 表中文名称,
    format('
drop table if exists `{}`;
create table if not exists `{}` (
{}
) engine=olap
unique key({})
comment ''{}''
distributed by hash({}) buckets 1;',
    table_name,
    table_name,
    column_list,
    key_list,
    table_cn,
    key_list) as "create table"
from tab
order by page, table_name










-- 生成 DWD 模型设计 Excel
select
    '每天' as 更新频率,
    'DWD' as 模式名,
    t.table_name as 表英文名称,
    t.table_comment as 表中文名称,
    c.column_name as 字段英文名称,
    c.column_comment as 字段中文名称,
    '' as 字段说明,
    upper(c.column_type) as 字段类型,
    '' as 字段长度,
    case column_key
        when 'UNI' then '是'
        else '否'
    end as 是否主键
from
    information_schema.columns as c
    inner join information_schema.tables as t using (table_schema, table_name)
where
    t.table_schema = 'dw_prod'
    and t.table_name like 'DWD\\_HR%'
order by
    t.table_name,
    ordinal_position







-- 规范化 varchar 长度
select concat(
    'alter table ', table_name, ' modify column ', column_name, ' ',
    case when character_maximum_length < 255 then 'varchar(255)'
    when  character_maximum_length < 6000 then 'varchar(6000)'
    else 'string' end,
    ';') as dml
from
    information_schema.columns
where
    table_schema = 'ods_prod' and table_name like 'ODS\\_DAD01\\_%'
    and column_type like 'varchar%' and column_type not in ('varchar(255)', 'varchar(6000)')
    and COLUMN_KEY = ''
order by
    table_name,
    ordinal_position    




---------------------------------------------------
--- scratch history
-- ADS 表建模
with numeric_t as (    -- 数值表
    select table_name, table_cn, 1 + unnest(range(max(d))) as i  -- topic index
    from (
        select table_name, table_cn, len(unnest(topics).path) as d
        from "D:\misc\minmetals\人力资源\人才管理.json"
        where topics is not null) as foo
    group by table_name, table_cn),
non_numeric as (        -- 非数值表，如信息列表
    select table_name, table_cn, unnest(columns) as c
    from "D:\misc\minmetals\人力资源\人才管理.json"
    where topics is null),
models as (
    select 
        table_name,
        table_cn,
        'topic_' || i as column_name,
        '话题' || i as column_cn,
        'VARCHAR(255)' as data_type,
        true as key
    from numeric_t
    union all
    select
        table_name,
        table_cn,
        c.column_name,
        c.column_cn,
        c.data_type,
        c.key
    from non_numeric),
result as (
    select *
    from models
    union all
    select  -- 数值表增加数值列
        table_name, 
        table_cn, 
        'val' as column_name,
        '数值' as column_cn,
        'DOUBLE' as data_type,
        false as key
    from (
        select distinct table_name, table_cn
        from numeric_t) as foo
    union all
    select      -- 全部表增加固定列
        table_name, 
        table_cn, 
        unnest(['org_code', 'ord_name', 'biz_date']) as column_name,
        unnest(['组织代码', '组织名称', '日期']) as column_cn,
        unnest(['VARCHAR(255)', 'VARCHAR(255)', 'VARCHAR(255)']) as data_type,
        false as key
    from (
        select distinct table_name, table_cn
        from models) as foo)
select 
    row_number() over (order by table_name, key desc) as 序号,
    '人力资源' as 业务域,
    '每日' as 更新频率,
    'ADS' as 域名,
    table_name as 表英文名称,
    table_cn as 表中文名称,
    column_name as 字段英文名称,
    column_cn as 字段中文名称,
    column_cn as 字段说明,
    data_type as 字段类型,
    case key when true then '是' else '否' end as 是否主键
from result



-- 话题树
with t as (
    select table_name, table_cn, unnest(topics) as topic
    from "D:\misc\minmetals\人力资源\人才管理.json"
    where topics is not null),
c as (
    select category, unnest(items) as item
    from "D:\misc\minmetals\人力资源\类别展开.json")
select 
    table_name as 表英文名称, 
    table_cn as 表中文名称,
    coalesce(c1.item, topic.path[1], '') as 话题1, 
    coalesce(c2.item, topic.path[2], '') as 话题2, 
    coalesce(c3.item, topic.path[3], '') as 话题3, 
    coalesce(c4.item, topic.path[4], '') as 话题4,
    topic.unit as 单位,
    coalesce(topic.comment, '') as 说明
from t left join c as c1 on topic.path[1] = '{' || c1.category || '}'
    left join c as c2 on topic.path[2] = '{' || c2.category || '}'
    left join c as c3 on topic.path[3] = '{' || c3.category || '}'
    left join c as c4 on topic.path[4] = '{' || c4.category || '}'
order by 1,2,3,4,5,6
