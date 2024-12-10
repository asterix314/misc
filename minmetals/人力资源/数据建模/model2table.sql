-- 主数据整理
load spatial;

insert into DIM_ORG_PATH
with recursive ods as (
    select '人事树' as src, *
    from st_read('D:\misc\minmetals\人力资源\人事树20241130.XLSX', layer='Sheet1', open_options=['headers=force', 'field_types=string'])
    union all by name
    select '管理树' as src, *
    from st_read('D:\misc\minmetals\人力资源\管理树20241130.XLSX', layer='Sheet1', open_options=['headers=force', 'field_types=string'])
    union all by name
    select '股权树' as src, *
    from st_read('D:\misc\minmetals\人力资源\股权树20241130.XLSX', layer='Sheet1', open_options=['headers=force', 'field_types=string'])),
org as (
    select 
        trim(组织机构代码) as org_cd, -- 组织机构代码
        any_value(nullif(trim(组织机构类型), '')) as org_typ, -- 组织机构类型
        any_value(trim(是否虚拟部门) = '1') as virt_entt, -- 是否虚拟部门
        any_value(nullif(trim(组织机构全称), '')) as org_cn_nm, -- 组织机构全称
        any_value(nullif(trim(组织机构简称), '')) as org_cn_abbr, -- 组织机构简称
        any_value(nullif(trim(企业类型), '')) as entp_typ, -- 企业类型
        any_value(nullif(trim(登记注册类型), '')) as reg_typ, -- 登记注册类型
        any_value(nullif(trim(统一社会信用代码), '')) as unit_soci_crdt_cd, -- 统一社会信用代码
        any_value(nullif(trim(工商注册登记号), '')) as reg_no, -- 工商注册登记号
        any_value(nullif(trim(全国组织机构代码), '')) as natn_org_cd, -- 全国组织机构代码
        any_value(nullif(trim(纳税人登记号), '')) as vat_no, -- 纳税人登记号
        any_value(nullif(trim(其他有效证件), '')) as oth_valid_no, -- 其他有效证件号
        any_value(nullif(trim(国家), '')) as cnty, -- 国家
        any_value(nullif(trim("省份/直辖市"), '')) as prvn, -- 省份/直辖市
        any_value(nullif(trim(城市), '')) as city, -- 城市
        any_value(nullif(trim(区县), '')) as town, -- 区县        
        any_value(nullif(trim("法定代表人/负责人"), '')) as legl_respn_ps, -- 法定代表人/负责人
        any_value(nullif(trim(注册地址), '')) as reg_addr, -- 注册地址
        any_value(nullif(trim(邮政编码), '')) as post_cd, -- 邮政编码
        any_value(nullif(trim(上级管理单位), '')) as upr_mng, -- 上级管理单位
        any_value(nullif(trim(管理组织排序码), '')) as mng_prox, -- 管理组织排序码
        any_value(nullif(trim(所属直管企业), '')) as grp_diret_mng_entp, -- 所属直管企业
        any_value(nullif(trim(股权属性), '')) as equt_typ, -- 股权属性
        any_value(nullif(trim(经营状态), '')) as opert_sts, -- 经营状态
        any_value(nullif(trim(上级人事单位), '')) as upr_hr_mng, -- 上级人事单位
        any_value(nullif(trim(人事组织排序码), '')) as hr_mng_prox, -- 人事组织排序码
        any_value(nullif(trim(上级股权单位), '')) as upr_equt_mng, -- 上级股权单位
        any_value(nullif(trim(股权组织排序码), '')) as equt_mng_prox -- 股权组织排序码
    from ods
    where trim(组织机构代码) != ''
    group by org_cd),
mng(org_cd, p) as (
    select '60000001', ['60000001']
    union all
    select org.org_cd, list_append(h.p, org.org_cd)
    from org inner join mng as h
        on org.upr_mng = h.org_cd),
hr(org_cd, p) as (
    select '60000001', ['60000001']
    union all
    select org.org_cd, list_append(h.p, org.org_cd)
    from org inner join hr as h
        on org.upr_hr_mng = h.org_cd),
equt(org_cd, p) as (
    select '60000001', ['60000001']
    union all
    select org.org_cd, list_append(h.p, org.org_cd)
    from org inner join equt as h
        on org.upr_equt_mng = h.org_cd),
org_ex as (
    select org.*, 
        mng.p as path_mng, 
        hr.p as path_hr, 
        equt.p as path_equt
    from org left join mng using (org_cd)
        left join hr using (org_cd)
        left join equt using (org_cd))
from org_ex


create table DIM_ORG_PATH(
    org_cd VARCHAR(255) not null comment '组织机构代码',
    org_typ VARCHAR(255) comment '组织机构类型',
    virt_entt BOOLEAN comment '是否虚拟部门',    
    org_cn_nm VARCHAR(255) comment '组织机构全称',
    org_cn_abbr VARCHAR(255) comment '组织机构简称',
    entp_typ VARCHAR(255) comment '企业类型',
    reg_typ VARCHAR(255) comment '登记注册类型',    
    unit_soci_crdt_cd VARCHAR(255) comment '统一社会信用代码',
    reg_no VARCHAR(255) comment '工商注册登记号',
    natn_org_cd VARCHAR(255) comment '全国组织机构代码',
    vat_no VARCHAR(255) comment '纳税人登记号',
    oth_valid_no VARCHAR(255) comment '其他有效证件号',
    cnty VARCHAR(255) comment '国家',
    prvn VARCHAR(255) comment '省份/直辖市',
    city VARCHAR(255) comment '城市',
    town VARCHAR(255) comment '区县',
    legl_respn_ps VARCHAR(255) comment '法定代表人/负责人',
    reg_addr VARCHAR(6000) comment '注册地址',
    post_cd VARCHAR(255) comment '邮政编码',
    upr_mng VARCHAR(255) comment '上级管理单位',
    mng_prox VARCHAR(255) comment '管理组织排序码',
    grp_diret_mng_entp VARCHAR(255) comment '所属直管企业',
    equt_typ VARCHAR(255) comment '股权属性',
    opert_sts VARCHAR(255) comment '经营状态',
    upr_hr_mng VARCHAR(255) comment '上级人事单位',
    hr_mng_prox VARCHAR(255) comment '人事组织排序码',
    upr_equt_mng VARCHAR(255) comment '上级股权单位',
    equt_mng_prox VARCHAR(255) comment '股权组织排序码',
    path_mng array<VARCHAR(255)> comment '管理层级路径',
    path_hr array<VARCHAR(255)> comment '人事层级路径',
    path_equt array<VARCHAR(255)> comment '股权层级路径'
) ENGINE=OLAP
UNIQUE KEY(`org_cd`)
COMMENT '组织机构主数据标准'
DISTRIBUTED BY HASH(`org_cd`) BUCKETS 1;
















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
