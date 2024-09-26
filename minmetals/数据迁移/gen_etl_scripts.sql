install mysql;
load mysql;
attach 'host=10.201.132.8 port=9030 user=public database=dw_dsep password=public@123,.' as doris (type mysql);
attach 'host=10.2.133.208 port=3306 user=root database=mcc password=Sunway612&' as 采购 (type mysql);
attach 'host=10.82.0.170 port=3306 user=root database=mcc password=root@2o22' as 党建人力 (type mysql);

with mcc_tab as (
    from mysql_query('mcc', 
        "select upper(table_name) as table_name, table_comment,  table_rows, data_length / pow(2,30) as table_GB
        from information_schema.tables
        where table_schema = 'mcc' and table_type = 'BASE TABLE'")),
mcc_col as (
    from mysql_query('mcc', 
        "select
            upper(table_name) as table_name, lower(column_name) as column_name,
            column_comment, ordinal_position, is_nullable, column_key, 
            upper(data_type) as data_type, character_maximum_length, numeric_precision, numeric_scale
        from information_schema.columns
        where table_schema = 'mcc'")),
dwd_tab as (
    select upper("表英文名称") as table_name, any_value("表中文名称") as table_comment
    from read_csv('C:\Users\zhangch2\Downloads\data\dwd.csv')
    group by table_name)
select *
from dwd_tab left join mcc_tab
    on dwd_tab.table_name = 'DWD_GYL_' || mcc_tab.table_name
where mcc_tab.table_name is null


-- 数据表基本信息
create table "数据表基本信息" as
with zh as (
    select upper("表英文名称") as table_name, any_value("表中文名称") as zh
    from read_csv('C:\Users\zhangch2\Downloads\data\dwd.csv')
    group by table_name),
bkt as (
    select "表英文名称" as table_name, string_agg("字段英文名称", ',') as "分桶字段"
    from "表字段信息"
    where "Key 列" = '是'
    group by "表英文名称")
from 
    mysql_query('doris', 
"select table_name, table_rows
from information_schema.tables
where table_schema = 'dw_dsep' and table_name like 'DWD\_GYL%'")
    left join zh using (table_name)
    left join bkt using (table_name)
select
    table_name as "表英文名称",
    coalesce(nullif(trim(zh), ''), table_name) as "描述",
    '唯一模型' as "表聚合类型",
    '不分区' as "分区策略",
    '' as "分区字段",
    '' as "分区时间粒度",
    '' as "保留最近分区数",
    '' as "提前创建未来分区数",
    '' as "初始化历史分区数",
    "分桶字段",
    case
        when table_rows >= 1_000_000 then 11 
        else 3
    end as "分桶数量"

    
    

-- 表字段信息
-- the following only generates the SQL text to query the actual data
from mysql_query('doris', "show tables like 'DWD\_GYL%'") as t(table_name)
select string_agg(format($$
select
    upper("table_name") as "表英文名称",
    "row_number" as "字段顺序号",
    lower("field") as "字段英文名称",
    coalesce(nullif(trim("Comment"), ''), lower("field")) as "字段描述",
    "std_type" as "字段类型",
    case "std_type"
        when 'VARCHAR' then '65533'
        when 'DECIMAL' then "length"
        else ''
    end as "长度",
    if("std_type" = 'DECIMAL', "precision", '') as "精度",
    if(upper("Key")='YES', '是', '否') as "Key 列",
    '' as "聚合类型",
    if(upper("Null")='NO', '是', '否') as "非空"
from (
    select '{0}' as "table_name",
        row_number() over (order by "Key" desc) as "row_number",
        "field", "Comment", "Key",  "Null",
        case regexp_extract("Type", '^\w+')
            when 'DATETIMEV2' then 'DATETIME'
            when 'DATEV2' then 'DATE'
            when 'VARCHAR' then 'VARCHAR'
            when 'TEXT' then 'VARCHAR'
            when 'STRING' then 'VARCHAR'
            when 'CHAR' then 'VARCHAR'
            when 'BIGINT' then 'BIGINT'
            when 'TINYINT' then 'INT'
            when 'INT' then 'INT'
            when 'DOUBLE' then 'DOUBLE'
            when 'DECIMALV3' then 'DECIMAL'
        end as "std_type",
        regexp_extract("Type", '\((\d+), (\d+)\)', 1) as "length",
        regexp_extract("Type", '\((\d+), (\d+)\)', 2) as "precision"
    from mysql_query('doris', 'show full columns from {0}')) as foo
$$, table_name), 'union all')



-- this generates the SQL scripts of ODS -> DWD
-- to run in duckdb
select format(
$$
/***********************************************************
任务名称：{0}
功能描述：
运行频率：每 N 分钟/小时/天 一次
输入表：
输出表：
加载策略：3 （注：1-全表覆盖 ，2-增量更新，3-增量追加）
创建时间：{1}
创建人：zhangch2
修改历史：
版本          更改日期          更改人             修改说明

***********************************************************/
-- truncate table dw{3}{4}.{0};

INSERT INTO
    dw{3}{4}.{0} 
    ({2})
select
    {2}
from
    ods{3}{4}.{5}
where
    etl_time > timestampadd (minute, -2, now ());
$$, 
    表英文名称,  -- {0}
    current_timestamp,  -- {1} 
    string_agg(字段英文名称, ',' order by 字段顺序号),  -- {2}
    '${',  -- {3}
    'env}',  -- {4}
    replace(表英文名称, 'DWD_GYL', 'ODS_CG')  -- {5}
    ) as "SQL"
from 表字段信息
where 字段英文名称 not in ('lastutd')
group by 表英文名称
order by 1
