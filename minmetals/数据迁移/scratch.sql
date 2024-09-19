install mysql;
load mysql;
ATTACH 'host=10.201.132.8 port=9030 user=public database=dw_dsep password=public@123,.' AS doris (TYPE MYSQL);




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