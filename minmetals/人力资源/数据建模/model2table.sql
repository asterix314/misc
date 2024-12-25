-- 在 duckdb 执行

load mysql;
create secret 数字底座 (
    type mysql,
    host '10.201.132.224',
    port 9030,
    user 'datakits_prod',
    password 'cisdi@123456'
);
create secret 干部人事 (
    type mysql,
    host '10.2.136.72',
    port 3306,
    user 'databaseuser',
    password 'hZH2AeEXijZDm1lc@'
);
attach 'database=ods_prod' as ods_prod (type mysql, secret 数字底座);
attach 'database=dw_prod' as dw_prod (type mysql, secret 数字底座);
attach 'database=information_schema' as infscm (type mysql, secret 数字底座);
attach 'database=gbrs_minmetals' as gbrs (type mysql, secret 干部人事);
load spatial;

-- 1. ODS 表通过数字底座同步到 doris 中

-- 1.1 增加入 doris 的表
select distinct upper(代码表)
from st_read('C:\Users\zhangch2\Downloads\data\干部管理schema.xlsx',
    layer = 'schema',
    open_options = ['HEADERS=FORCE'])
where len(trim(代码表)) > 0
except
select replace(table_name, 'ODS_DAB01_', '')
from tables
where table_catalog = 'HR_CADRE'
order by 1


-- 2. doris 中新建表信息导入 duckdb 
insert into tables by name
from infscm.tables as i
where table_schema in ('ods_prod', 'dw_prod', 'ads_prod') and not exists (
    select 1 from test.tables as t
    where (i.table_schema, i.table_name) = (t.table_schema, t.table_name))

insert into test.columns by name
from infscm.columns as i
where table_schema in ('ods_prod', 'dw_prod', 'ads_prod') and not exists (
    select 1 from test.columns as c
    where (i.table_schema, i.table_name) = (c.table_schema, c.table_name))    

    
-- 3. schema annotation
-- 3.1 table_catalog, table_type, 
-- update tables set table_catalog = 'HR_CADRE'
where table_schema = 'ods_prod' and table_name like 'ODS_DAB01_%'
-- update tables
-- set table_type = '维度表'
where regexp_extract(table_name, 'ODS_DAB01_([A-Z]+)', 1) in ('HR', 'GB', 'GBT', 'ZB', 'TJ')


-- 3.2 table comment
with u as (
    select upper(代码表) as table_name, any_value(字段中文) as table_comment
    from st_read('C:\Users\zhangch2\Downloads\data\干部管理schema.xlsx',
        layer = 'schema',
        open_options = ['HEADERS=FORCE'])
    where coalesce(trim(代码表), '') != ''
    group by 代码表)
update tables as t
set table_comment = u.table_comment
from u
where t.table_schema = 'ods_prod' and t.table_name = 'ODS_DAB01_' || u.table_name 

-- check for duplicate table comments
select table_comment
from tables
where table_catalog = 'HR_CADRE'
group by table_comment having count(1) > 1



-- 3.3 column comment and extras (从外部设计文档)
create temp table if not exists columns_augment (
    table_name varchar,
    column_name varchar,
    column_comment varchar,
    extra varchar);

truncate table columns_augment;
    
insert into columns_augment by name
select trim(表名) as table_name, trim(字段名) as column_name, trim(字段中文) as column_comment
from st_read('C:\Users\zhangch2\Downloads\data\干部管理schema.xlsx',
    layer = 'schema',
    open_options = ['HEADERS=FORCE'])
where coalesce(trim(代码表), '') = ''

-- 在 duckdb 执行生成的结果
select printf(
'insert into columns_augment by name
select ''%s'' as table_name, ''%s'' as column_name, ''%s'' as column_comment,  string_agg(format(''{}：{}'', dmcod, dmcpt), ''
'' order by inpfrq) as extra
from gbrs.%s;', trim(表名), trim(字段名), trim(字段中文), coalesce(trim(代码表), '')) as qry
from st_read('C:\Users\zhangch2\Downloads\data\干部管理schema.xlsx',
    layer = 'schema',
    open_options = ['HEADERS=FORCE'])
where coalesce(trim(代码表), '') != ''

-- 更新 column comment、 extra
update columns as c set 
    column_comment = coalesce(nullif(a.column_comment, ''), c.column_comment),  
    extra = coalesce(nullif(a.extra, ''), c.extra)
from columns_augment as a
where c.table_schema = 'ods_prod'
    and c.table_name = 'ODS_DAB01_' || a.table_name 
    and c.column_name = a.column_name
    
-- in case of extremely long extras
update columns
set extra = left(extra, 255) || '……'
where TABLE_SCHEMA = 'ods_prod' and table_name like 'ODS_DAB01%' and length(extra) > 255


-- 4. 生成 doris alter table/column comment 语句 并在 doris 中执行
select format('alter table {} modify comment "{}";', table_name, table_comment)
from tables
where table_catalog = 'HR_CADRE' and trim(table_comment) != ''

select format('alter table {} modify column {} comment "{}";', table_name, column_name, column_comment)
from columns
where table_schema = 'ods_prod' and table_name like 'ODS\_DAB01\_%' escape '\' and trim(column_comment) != ''


-- 5. 逆向建模 ODS

-- 6. 自动生成 ODS、DWD、DIM 模型文档页或建表语句 (dudkdb)
with base as (
    -- 源：duckdb
    select
        t.table_catalog,    -- 业务域
        t.table_type,   -- 事实表/维度表
        upper(trim(t.table_name)) as ods_name,
        regexp_replace(ods_name, 'ODS_[[:alnum:]]+', if(table_type = '事实表', 'DWD', 'DIM') || '_' || t.table_catalog) as dw_name,
        coalesce(trim(t.table_comment), '') as table_cn,
        trim(c.column_name) as column_name,
        coalesce(trim(c.column_comment), '') as column_cn,  -- 字段中文名称
        c.column_key = 'UNI' as is_key,
        c.column_type as ods_dtype,
        case 
            when c.data_type like '%char' and (c.character_maximum_length <= 255 or is_key) then 'VARCHAR(255)'
            when c.data_type like '%char' and character_maximum_length <= 6000 then 'VARCHAR(6000)'
            when c.data_type like '%char' then 'STRING'
            when c.data_type = 'decimal' and numeric_scale = 0 then 'BIGINT'
            when c.data_type = 'decimal' then 'DOUBLE'
            else upper(c.column_type)
        end as dw_dtype,
        trim(c.extra) as extra, -- 字段说明
        true as original,   -- from ODS table 
        c.ordinal_position as r
    from
        columns as c
        inner join tables as t using (table_schema, table_name)
    where
        t.table_schema = 'ods_prod' and t.table_catalog = 'HR_CADRE'),
fixture as (
    select   -- 对事实表增加贯标列
        table_catalog,
        table_type,
        ods_name,
        dw_name,
        table_cn,
        false as is_key,
        false as original,
        '' as extra,
        unnest([
            {'column_name': 'org_cd', 'column_cn': '组织机构代码', 'ods_dtype': 'varchar(255)', 'dw_dtype': 'VARCHAR(255)', 'r': 501},
            {'column_name': 'org_cn_abbr', 'column_cn': '组织机构简称', 'ods_dtype': 'varchar(255)', 'dw_dtype': 'VARCHAR(255)','r': 502},
            {'column_name': 'biz_date', 'column_cn': '业务日期', 'ods_dtype': 'varchar(8)', 'dw_dtype': 'VARCHAR(8)', 'r': 503}], recursive:=true)
    from (
        select distinct table_catalog, table_type, ods_name, dw_name, table_cn
        from base 
        where table_type = '事实表')),        
clist as (
    from base
    union all by name
    from fixture
    where (table_catalog, ods_name, column_name) not in 
        (select struct_pack(table_catalog, ods_name, column_name) from base)),
ods_model as (
    select
        '每天' as 更新频率,
        'ODS' as 模式名,
        ods_name as 表英文名称,
        table_cn as 表中文名称,
        column_name as 字段英文名称,
        column_cn as 字段中文名称,
        ''  as 字段说明,
        upper(ods_dtype) as 字段类型,
        if(is_key, '是', '否') as 是否主键
    from clist where original
    order by ods_name, r),
dw_model as (
    select
        '每天' as 更新频率,
        if(table_type = '事实表', 'DWD', 'DIM') as 模式名,
        dw_name as 表英文名称,
        table_cn as 表中文名称,
        lower(column_name) as 字段英文名称,
        column_cn as 字段中文名称,
        coalesce(extra, '') as 字段说明,
        dw_dtype as 字段类型,
        if(is_key, '是', '否') as 是否主键
    from clist
    order by dw_name, r),
tlist as (
    select ods_name, dw_name, table_cn,
        string_agg(format('`{}`', column_name), ', ' order by r) filter (is_key) as key_list,
        string_agg(format('`{}`', column_name), ', ' order by r) as cname_list,
        string_agg(format('`{}`', column_name), ', ' order by r) filter (original) as original_list,
        string_agg(format('`{}` {} {} comment "{}"', 
            column_name, 
            dw_dtype, 
            if(is_key, 'not null', 'null'), 
            column_cn), ', ' order by r) as cdef_list
    from clist
    group by all), 
dw_ddl as (
    select 
        dw_name as 表英文名称,
        table_cn as 表中文名称,
        format('drop table if exists `{0}`;
create table if not exists dw${{env}}.`{0}` ({1}) 
engine=olap
unique key({2})
comment "{3}"
distributed by hash({2}) buckets 1;',
            dw_name, cdef_list, key_list, table_cn) as ddl
    from tlist
    order by dw_name),
dw_dml as (
    select
        dw_name as 表英文名称,
        table_cn as 表中文名称,
        format('insert into dw${{env}}.`{0}`({1})
select {1}
from ods${{env}}.`{2}`;',
            dw_name,
            original_list,
            ods_name) as dml
    from tlist
    order by dw_name)
from dw_dml
    
    

-- 7. 
with base as (
    -- 源：JSON 配置文件
        select page, table_name, table_cn, unnest(columns, recursive:=true),
            generate_subscripts(columns, 1) as r
        from "D:\misc\minmetals\人力资源\数据建模\干部管理DWS.json"),
fixture as (
    select   -- 对事实表增加贯标列
        *,
        false as key,
        unnest([
            {'column_name': 'org_cd', 'column_cn': '组织机构代码', 'data_type': 'VARCHAR(8)', 'r': 501},
            {'column_name': 'org_cn_abbr', 'column_cn': '组织机构简称', 'data_type': 'VARCHAR(200)','r': 502},
            {'column_name': 'biz_date', 'column_cn': '业务日期', 'data_type': 'VARCHAR(8)', 'r': 503}], recursive:=true)
    from (
        select distinct page, table_name, table_cn
        from base)),        
clist as (
    from base
    union all by name
    from fixture
    where (page, table_name, column_name) not in 
        (select struct_pack(page, table_name, column_name) from base)),
model as (
    select
        '每天' as 更新频率,
        'DWS' as 模式名,
        table_name as 表英文名称,
        table_cn as 表中文名称,
        lower(column_name) as 字段英文名称,
        column_cn as 字段中文名称,
        coalesce(unit, '') as 单位,
        coalesce(description, '') as 字段说明,
        data_type as 字段类型,
        if(key, '是', '否') as 是否主键
    from clist
    order by table_name, r),
tlist as (
    select table_name, table_cn,
        string_agg(format('`{}`', column_name), ', ' order by r) filter (key) as key_list,
        string_agg(format('`{}`', column_name), ', ' order by r) as cname_list,
        string_agg(format('`{}` {} {} comment ''{}''',
            column_name, 
            data_type, 
            if(key, 'not null', 'null'), 
            column_cn), ', ' order by r) as cdef_list
    from clist
    group by all),
ddl as (
    select 
        table_name as 表英文名称,
        table_cn as 表中文名称,
        format('drop table if exists `{0}`;
create table if not exists `{0}` ({1}) 
engine=olap
unique key({2})
comment ''{3}''
distributed by hash({2}) buckets 1;',
            table_name, cdef_list, key_list, table_cn) as ddl
    from tlist
    order by table_name)
from ddl






-- 导入机构映射
INSERT INTO dw_prod.DIM_ORG_MAP
(biz, biz_name, biz_code, org_cd, org_cn_nm, org_cn_abbr, valid, update_time)
select '采购管理', 采购单位名称, 采购单位编码, "4A单位编码", "4A单位名称", 采购单位名称, 1, now()
from st_read(
    'C:\Users\zhangch2\Downloads\采购组织机构与主数据匹配一致单位详细.xlsx',
    layer = 'Sheet1',
    open_options = ['HEADERS=FORCE']) as x



-- unnest MAP
with p as (
    pivot (
        select 
            unnest(map_keys(json)) as key, 
            unnest(map_values(json)) as value,
            row_number () over () as i
        from zbbmdzs)
    on key
    using first(value)
    order by i)
select * exclude i
from p







--------------------------------
