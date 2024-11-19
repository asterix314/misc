-- ADS 表清单
with jsn as (
    select page, table_name, table_cn,
        c.column_name, c.column_cn, c.data_type, c.key,
        row_number() over (partition by page, table_name) as r
    from (
        select page, table_name, table_cn, unnest(columns) as c
        from "D:\misc\minmetals\人力资源\数据建模\*.json") as foo),
t as (
    select *
    from jsn
    union all
    select   -- 增加固定列
        page,
        table_name, 
        table_cn, 
        unnest(['org_code', 'org_name', 'biz_date']) as column_name,
        unnest(['组织代码', '组织名称', '日期']) as column_cn,
        unnest(['VARCHAR(255)', 'VARCHAR(255)', 'VARCHAR(255)']) as data_type,
        false as key,
        unnest([101, 102, 103]) as r
    from (
        select distinct page, table_name, table_cn
        from jsn) as foo),
t2 as (
    select 
        page,
        table_name, 
        any_value(table_cn) as table_cn, 
        column_name, 
        any_value(column_cn order by r) as column_cn,
        any_value(data_type order by r) as data_type, 
        any_value(key order by r) as key,
        any_value(r) as r
    from t
    group by page, table_name, column_name),
t3 as (
    select page, table_name, any_value(table_cn) as table_cn,
        string_agg(format('`{}`', column_name) order by r) filter (key) as key_list,
        string_agg(format('    `{}` {} {} comment ''{}''',
            column_name,
            data_type,
            if(key, 'not null', 'null'),
            column_cn), ',
' order by r) as column_list
    from t2
    group by page, table_name)
select 
    page as 页面,
    '每日' as 频率,
    'ADS' as 域名,
    table_name as 表英文名称,
    table_cn as 表中文名称,
    format('
drop table if exists ads_prod.`{}`;
create table if not exists ads_prod.`{}` (
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
from t3
order by page, table_name



-- ADS 表字段信息
with jsn as (
    select table_name, table_cn,
        c.column_name, c.column_cn, c.data_type, c.description, c.unit, c.key
    from (
        select table_name, table_cn, unnest(columns) as c
        from "D:\misc\minmetals\人力资源\数据建模\薪酬效能.json") as foo),
result as (
    select *
    from jsn
    union all
    select   -- 增加固定列
        table_name, 
        table_cn, 
        unnest(['org_code', 'ord_name', 'biz_date']) as column_name,
        unnest(['组织代码', '组织名称', '日期']) as column_cn,
        unnest(['VARCHAR(255)', 'VARCHAR(255)', 'VARCHAR(255)']) as data_type,
        null as description, null as unit, false as key
    from (
        select distinct table_name, table_cn
        from jsn) as foo)
select distinct
    table_name as 表英文名称,
    table_cn as 表中文名称,
    column_name as 字段英文名称,
    column_cn as 字段中文名称,
    coalesce(unit, '') as 单位,
    coalesce(description, '') as 字段说明,
    data_type as 字段类型,
    case key when true then '是' else '否' end as 是否主键
from result
order by 表英文名称, 字段英文名称








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
