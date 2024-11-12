-- generate SQL to run in doris
with t as (
    select table_name, right(table_comment, char_length(table_comment) - 6) as case_type 
    from information_schema.tables
    where table_schema = 'ods_prod' and table_name like 'ODS\_FL%'),
t2 as (
    select replace(replace('
    select ''{case_type}'' as 案件类型, ccompany as 公司, count(1) as 案件数
    from {table_name}
    group by ccompany
    ', 
    '{case_type}', case_type), '{table_name}', table_name) as q
    from t)
select GROUP_CONCAT(q, 'union all')
from t2



----------------------------

with t as (
    select '刑事二审' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLAXSES
    group by ccompany
    union all
    select '刑事一审' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLAXSYS
    group by ccompany
    union all
    select '首次执行' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLASCZX
    group by ccompany
    union all
    select '刑事再审' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLAXSZS
    group by ccompany
    union all
    select '财产保全执行案件' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLACCBQZX
    group by ccompany
    union all
    select '民事再审' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLAMSZS
    group by ccompany
    union all
    select '行政二审' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLAXZES
    group by ccompany
    union all
    select '行政一审' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLAXZYS
    group by ccompany
    union all
    select '执行异议' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLAZXYY
    group by ccompany
    union all
    select '恢复执行' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLAHFZX
    group by ccompany
    union all
    select '民事一审' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLAMSYS
    group by ccompany
    union all
    select '行政再审' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLAXZZS
    group by ccompany
    union all
    select '民事二审' as 案件类型, ccompany as 公司, count(1) as 案件数
    from ODS_FL_XZLAMSES
    group by ccompany),
ru as (
    select *
    from t
    union all
    select 案件类型, '<五矿集团>', sum(案件数)
    from t
    group by 案件类型)
select *
from ru 
order by 公司, 案件类型

