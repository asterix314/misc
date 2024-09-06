-- 供应商管理
-- 要素：履约风险
-- 体征：规模较小，履约能力不足。
-- 应用名称：GYS15

drop table if exists ods_dsep_test.ADS_GYS_15;
create table ods_dsep_test.ADS_GYS_15
unique key(uuid) as 
select
    md5 (uuid ()) as uuid,
    '0' as onuse,
    cast(null as datetime) as etl_time,
    strleft (gysbm, 3) as zgqybm,
    gysbm,
    gysmc,
    tyshxydm,
    zrdwbm,
    zrdwmc,
    zczj,
    yyzz,
    sfzr,
    ywlx,
    zbbm,
    approvedate,
    fwgxdwmc
from
    (
        with
            dwmc as (
                select
                    f.dwbm,
                    group_concat (distinct w.dwmc) as fwgxdwmc
                from
                    dw_ods_dsep.ods_cg_xtghdw_a_fwgx as f
                    inner join dw_ods_dsep.ods_cg_xtlldw as w on 
                        f.zzjg = w.dwbm
                group by
                    f.dwbm
            ),
            main as (
                select
                    a.dwbm as gysbm,
                    a.dwmc as gysmc,
                    a.yyzz as tyshxydm,
                    a.tjdwbm as zrdwbm,
                    a.tjdwmc as zrdwmc,
                    a.zczj,
                    a.yyzz,
                    '1' as sfzr,
                    'ht' as ywlx,
                    b.htbm as zbbm,
                    cm.approvedate
                from
                    dw_ods_dsep.ods_cg_xtghdw as a
                    inner join dw_ods_dsep.ods_cg_cght as b on 
                        a.dwbm = b.dwbm
                    inner join dw_ods_dsep.ods_cg_t_audit_comment as cm on 
                        b.htbm = cm.billid
                where
                    b.swbz = '1'
                    and b.je > 50000 * a.zczj
                    and b.businessclassification != '001' -- 排除掉服务类
                    and cm.tablename = 'CGHT'
                    and cm.type = '0'
            )
        select
            *
        from
            main
            left join dwmc on main.gysbm = dwmc.dwbm
    ) as ads

/*** 带参数抽取 ADS 示例 ***

select distinct
    gysbm,
    gysmc,
    tyshxydm,
    zrdwbm,
    zrdwmc,
    zczj,
    '1' sfzr,
    'ht' ywlx,
    zbbm,
    fwgxdwmc
from ADS_GYS_15
where true
    and approvedate >= '2024-09-01' -- <if test=starttime != null>
    and approvedate <= '2024-10-01' -- <if test=endtime != null>
    and yyzz = 'xxxx' -- <if test=tyshxydm != null>

******/



-- MySQL test set

SELECT DISTINCT
    A.DWBM gysbm,
    A.DWMC gysmc,
    A.YYZZ tyshxydm,
    A.TJDWBM zrdwbm,
    A.TJDWMC zrdwmc,
    A.ZCZJ zczj,
    '1' sfzr,
    'HT' ywlx,
    B.HTBM zbbm,
    (
        SELECT
            GROUP_CONCAT (DISTINCT W.DWMC)
        FROM
            XTGHDW_A_FWGX F,
            XTLLDW W
        WHERE
            F.ZZJG = W.DWBM
            AND F.DWBM = A.DWBM
    ) fwgxdwmc
FROM
    XTGHDW A,
    CGHT B
WHERE
    A.DWBM = B.DWBM
    AND B.SWBZ = '1'
    AND B.HTBM IN (
        SELECT
            CM.BILLID
        FROM
            T_AUDIT_COMMENT CM
        WHERE
            CM.TABLENAME = 'CGHT'
            AND CM.TYPE = '0'
            AND B.BUSINESSCLASSIFICATION <> '001' -- 排除掉服务类
            -- <if test=""startTime!=null"">
            AND CM.APPROVEDATE >= '2024-01-01' -- #{startTime}
            -- </if>
            -- <if test=""endTime!=null"">
            AND CM.APPROVEDATE < '2024-09-01' -- #{endTime}
            -- </if>
            -- <if test=""tyshxydm!=null"">
            --         AND A.YYZZ = #{tyshxydm}
            -- </if>
    )
    AND B.JE > 50000 * A.ZCZJ
