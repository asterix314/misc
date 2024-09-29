-- in duckdb.
-- first prepare local tables `table_info` and `column_info` to take stock of all the table metadata.

load mysql;
attach 'host=10.201.132.8 port=9030 user=public database=dw_dsep password=public@123,.' as doris (type mysql);
attach 'host=10.2.133.208 port=3306 user=root database=mcc password=Sunway612&' as 采购 (type mysql);
attach 'host=10.82.0.170 port=3306 user=root database=mcc password=root@2o22' as 党建人力 (type mysql);


truncate table table_info

insert into table_info  -- if nonexistant, CTAS
from mysql_query('采购', $$
select table_schema, 
    table_name, 
    table_rows, 
    avg_row_length, 
    data_length, 
    create_time, 
    update_time, 
    table_comment
from information_schema.tables
where 
    table_schema in ('mcc') 
    and table_type = 'BASE TABLE' and table_name != 'test' $$);

insert into table_info
from mysql_query('党建人力', $$
select table_schema, 
    table_name, 
    table_rows, 
    avg_row_length, 
    data_length, 
    create_time, 
    update_time, 
    table_comment
from information_schema.tables
where 
    table_schema in (
        'minmetals_monitor', -- 人力 and what not
        'ods_wkdjdb') -- 党建 
    and table_type = 'BASE TABLE' and table_name != 'test' $$);


truncate table column_info

insert into column_info -- if nonexistant, CTAS
from mysql_query(
    '采购',
    $$
    select
        table_schema,
        table_name,
        column_name,
        ordinal_position,
        is_nullable,
        data_type,
        character_maximum_length,
        numeric_precision,
        numeric_scale,
        column_key,
        column_comment
    from
        information_schema.columns
    where
        table_schema in ('mcc') and table_name != 'test'$$
)


insert into column_info
from mysql_query(
    '党建人力',
    $$
    select
        table_schema,
        table_name,
        column_name,
        ordinal_position,
        is_nullable,
        data_type,
        character_maximum_length,
        numeric_precision,
        numeric_scale,
        column_key,
        column_comment
    from
        information_schema.columns
    where
        table_schema in ('ods_wkdjdb', 'minmetals_monitor') and table_name != 'test'$$
)






-- 数据导入模板

-- 数据表基本信息页
-- 唯一模型、不分区、分桶数量随表增长。
with t as (
    select if(table_name ilike 'cg\_%' escape '\', 'dwd_', 'dwd_cg_') as prefix, *
    from table_info
    where
        table_schema = 'mcc' 
    and (
        table_name like 'cg%'
        or table_name like 'xtghdw%'
        or table_name like 'ztb%'))
select
    upper(prefix || table_name) as "表英文名称",
    coalesce(
        nullif(trim(table_comment), ''),
        upper(prefix || table_name)) as "描述",
    '唯一模型' as "表聚合类型",
    '不分区' as "分区策略",
    '' as "分区字段",
    '' as "分区时间粒度",
    '' as "保留最近分区数",
    '' as "提前创建未来分区数",
    '' as "初始化历史分区数",
    '' as "分桶字段",
    floor(1 + table_rows/5e6) as "分桶数量"
from t


-- 表字段信息页
with t as (
    select 
        if(table_name ilike 'cg\_%' escape '\', 'dwd_', 'dwd_cg_') as prefix,
        lower(column_name) as cname,
        lower(data_type) as dtype, *
    from column_info
    where
        table_schema = 'mcc' 
    and (
        table_name like 'cg%'
        or table_name like 'xtghdw%'
        or table_name like 'ztb%'))
from t
select
    upper(prefix || table_name) as "表英文名称",
    ordinal_position as "字段顺序号",
    cname as "字段英文名称",
    coalesce(nullif(trim(column_comment), ''), cname) as "字段描述",
    case 
        when dtype = 'largeint' then 'largeint'
        when dtype like '%int' then 'bigint'
        when dtype in ('float', 'double') then 'double'
        when dtype in ('char', 'varchar', 'enum') then 'varchar'
        when dtype like '%text' then 'string'
        when dtype in ('timestamp', 'datetime') then 'datetime'
        when dtype in ('decimal', 'boolean', 'date', 'time') then dtype
    end as "字段类型",
    case 
        when dtype in ('char', 'varchar', 'enum') then '65533'
        when dtype = 'decimal' then cast(numeric_precision as char)
        else ''
    end as "长度",
    case 
        when dtype = 'decimal' then cast(numeric_scale as char)
        else ''
    end as "精度",
    if(column_key = 'UNI', '是', '否') as "Key 列",
    '' as "聚合类型",
    if(is_nullable='NO', '是', '否') as "非空"
