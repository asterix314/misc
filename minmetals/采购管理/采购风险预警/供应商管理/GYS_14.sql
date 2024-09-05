-- 供应商管理
-- 要素：履约风险
-- 体征：存在合同违约情形、注册阶段存在较大风险，影响履约能力、入库后发生较大变故，影响履约能力。
-- 应用名称：GYS14

drop table if exists ods_dsep_test.ADS_GYS_14;
create table ods_dsep_test.ADS_GYS_14
unique key(uuid) as
select
    md5 (uuid ()) as uuid,
    '0' as onuse,
    cast(null as datetime) as etl_time,
    strleft(gysbm, 3) as zgqybm,
    gysmc,
    gysbm,
    tyshxydm,
    zczb,
    fddbr,
    dwdz,
    yyzzyxq,
    zrdwmc,
    zrdwbm,
    sfzr,
    ywlx,
    compare_time,
    yyzz,
    fwgxdwmc
from
    (
        with
            dwmc as (
                select
                    f.dwbm,
                    group_concat (x.dwmc, ',') as fwgxdwmc
                from
                    dw_ods_dsep.ods_cg_xtghdw_a_fwgx as f
                    inner join dw_ods_dsep.ods_cg_xtlldw as x on f.zzjg = x.dwbm
                group by
                    f.dwbm
            ),
            main as (
                select
                    dwmc as gysmc,
                    dwbm as gysbm,
                    yyzz as tyshxydm,
                    zczj as zczb,
                    fr as fddbr,
                    dwdz,
                    yyzzyxq,
                    tjdwmc as zrdwmc,
                    tjdwbm as zrdwbm,
                    sfzr,
                    'cxzr' as ywlx,
                    shrq as compare_time,
                    yyzz
                from
                    dw_ods_dsep.ods_cg_xtghdw
                where
                    shbz = '2'
                union all
                select
                    d.dwmc as gysmc,
                    d.dwbm as gysbm,
                    d.yyzz as tyshxydm,
                    d.zczj as zczb,
                    d.fr as fddbr,
                    d.dwdz,
                    d.yyzzyxq,
                    d.tjdwmc as zrdwmc,
                    d.tjdwbm as zrdwbm,
                    d.sfzr,
                    'qy' as ywlx,
                    q.shsj as compare_time,
                    d.yyzz
                from
                    dw_ods_dsep.ods_cg_xtghdw as d
                    inner join dw_ods_dsep.ods_cg_xtghdw_yw_da_qysq as q on q.gysbm = d.dwbm
                where
                    q.shbz = '2'
                    and q.zbshbz = '0'
            )
        select
            *
        from
            main
            left join dwmc on main.gysbm = dwmc.dwbm
    ) as ads

/*** 带参数抽取 ADS 示例 ***

select
    gysmc,
    gysbm,
    tyshxydm,
    zczb,
    fddbr,
    dwdz,
    yyzzyxq,
    zrdwmc,
    zrdwbm,
    sfzr,
    ywlx,
    fwgxdwmc
from ADS_GYS_14
where true 
    and compare_time >= '2024-08-01' -- <if test=starttime != null>
    and compare_time <= '2024-09-01' -- <if test=endtime != null>
    and yyzz = 'xxxx' -- <if test=tyshxydm != null>

******/