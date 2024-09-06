-- 供应商管理：违规注册
-- 体征：黑名单企业变相入库
-- 应用名称：GYS03

drop table if exists ods_dsep_test.ADS_GYS_03_2;
create table ods_dsep_test.ADS_GYS_03_2
unique key(uuid) as 



-- MySQL test set
SELECT
    T.DWMC gysmc,
    T.DWBM gysbm,
    T.TJDWBM zrdwbm,
    T.TJDWMC zrdwmc,
    T.fr fddbr,
    '0' sfzr,
    'ZC' ywlx,
    T.SHRQ
FROM
    b2b_ghdw T
WHERE
    T.SHBZ = '2'
    AND NOT EXISTS (
        SELECT
            1
        FROM
            XTGHDW G
        WHERE
            G.DWBM = T.GHDWID
    )
    -- <if test=""startTime != null"">
    AND T.SHRQ >= '2024-01-01' -- #{startTime}
    -- </if>
    -- <if test=""endTime != null"">
    AND T.SHRQ < '2024-09-01' -- #{endTime}
    -- </if>
UNION ALL
SELECT
    T.DWMC gysmc,
    T.DWBM gysbm,
    T.TJDWBM zrdwbm,
    T.TJDWMC zrdwmc,
    T.fr fddbr,
    T.SFZR sfzr,
    'CXZR' ywlx,
    T.SHRQ
FROM
    xtghdw T
WHERE
    T.SHBZ = '2'
    -- <if test=""startTime != null"">
    AND T.SHRQ >= '2024-01-01' -- #{startTime}
    -- </if>
    -- <if test=""endTime != null"">
    AND T.SHRQ < '2024-09-01' -- #{endTime}
    -- </if>
UNION ALL
SELECT
    T.DWMC gysmc,
    T.DWBM gysbm,
    T.TJDWBM zrdwbm,
    T.TJDWMC zrdwmc,
    T.fr fddbr,
    T.SFZR sfzr,
    'QY' ywlx,
    T.SHRQ
FROM
    xtghdw T,
    XTGHDW_YW_DA_QYSQ Q
WHERE
    Q.GYSBM = T.DWBM
    AND Q.SHBZ = '2'
    AND Q.ZBSHBZ = '0'
    -- <if test=""startTime != null"">
    AND Q.SHSJ >= '2024-01-01' -- #{startTime}
    -- </if>
    -- <if test=""endTime != null"">
    AND Q.SHSJ < '2024-09-01' -- #{endTime}
    -- </if>