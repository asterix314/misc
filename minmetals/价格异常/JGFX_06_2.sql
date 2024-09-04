-- 价格异常：采购价格偏离市场
-- 体征：预中标价格偏离市场价：
    -- 螺纹、线材、圆钢预，偏离 30-200元/吨；
    -- H型钢预，偏离 30-200元/吨；
    -- 混凝土，偏离 6-30元/吨；
    -- 工角槽、扁钢，偏离 30-200元/吨；
    -- 板、卷钢，偏离 30-200元/吨；
-- 应用名称：JGFX06

drop table if exists ods_dsep_test.ADS_JGFX_06_2;
create table ods_dsep_test.ADS_JGFX_06_2
unique key(uuid) as
select
    md5 (uuid ()) as uuid,
    '0' as onuse,
    cast(null as datetime) as etl_time,
    mima.data_value,
    mima.data_date,
    mimi.breed_code,
    mimi.sc_code,
    mimi.market_code,
    mimi.mq_code,
    mimi.cp_code
from
    dw_ods_dsep.ods_mb_index_main_info_v2 as mimi
    inner join dw_ods_dsep.ods_mb_index_main_data_v2 as mima on mima.index_code = mimi.index_code
where
    mimi.metric_name = '市场价格'




/*** 带参数抽取 ADS 示例 ***


select
    avg(data_value) as priceaverage
from ADS_JGFX_06_2
where
    breed_code = 'ST-0000001562'        -- #{code}
    and data_date = '2023-07-14'        -- #{startdate}
    and sc_code = 'SC-0000005191'       -- #{specification}
    and market_code = 'AR-0000000869'   -- #{city}
    and mq_code = 'MQ-0000001093'       -- #{material}, if test=material != null and material !=''
    and cp_code = 'CP-0000008909'       -- #{zzppbm} <if test=zzppbm != null and zzppbm!=''>

********/