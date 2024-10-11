-- in duckdb.



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
