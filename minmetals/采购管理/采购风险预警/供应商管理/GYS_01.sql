-- 供应商管理：违规注册
-- 体征：注册信息与企业基本信息不符
-- 应用名称：GYS01

drop table if exists ods_dsep_test.ADS_GYS_01;
create table ods_dsep_test.ADS_GYS_01
unique key(uuid) as 



-- MySQL test set
SELECT
    D.DWMC gysmc,
    D.DWBM gysbm,
    D.YYZZ tyshxydm,
    D.ZCZJ zczb,
    D.FR fddbr,
    D.DWDZ dwdz,
    (
        SELECT
            IFNULL (YWPK10, 0)
        FROM
            XTXXFJ
        WHERE
            YWPK01 = D.GHDWID
            AND YWBM = 'GYS13'
        LIMIT
            1
    ) sfcq,
    (
        SELECT
            YWPK02
        FROM
            XTXXFJ
        WHERE
            YWPK01 = D.GHDWID
            AND YWBM = 'GYS13'
        LIMIT
            1
    ) qsrq,
    (
        SELECT
            YWPK03
        FROM
            XTXXFJ
        WHERE
            YWPK01 = D.GHDWID
            AND YWBM = 'GYS13'
        LIMIT
            1
    ) jsrq,
    D.TJDWMC zrdwmc,
    D.TJDWBM zrdwbm,
    '0' sfzr,
    'ZC' ywlx,
    (
        SELECT
            COUNT(1)
        FROM
            XTGHDW_YW_ZR_ZRPSFA A,
            XTGHDW_YW_ZR_ZRPSFA_GYS B
        WHERE
            A.ZRPSFABM = B.ZRPSFABM
            AND B.GYSBM = D.DWBM
            AND A.SHBZ = '2'
    ) sfps,
    (
        SELECT
            GROUP_CONCAT (X.DWMC SEPARATOR ',')
        FROM
            XTGHDW_A_FWGX F,
            XTLLDW X
        WHERE
            F.DWBM = D.DWBM
            AND X.DWBM = F.ZZJG
    ) FWGXDWMC
FROM
    B2B_GHDW D
WHERE
    D.SHBZ = '2'
    -- <if test=""startTime != null"">
    AND D.SHRQ >= '2024-01-01' -- #{startTime}
    -- </if>
    -- <if test=""endTime != null"">
    AND D.SHRQ < '2024-09-01' -- #{endTime}
    -- </if>
    -- <if test=""tyshxydm != null"">
    --    AND d.YYZZ = #{tyshxydm}
    -- </if>
UNION
SELECT
    D.DWMC gysmc,
    D.DWBM gysbm,
    D.YYZZ tyshxydm,
    D.ZCZJ zczb,
    D.FR fddbr,
    D.dwdz,
    (
        SELECT
            IFNULL (YWPK10, 0)
        FROM
            XTXXFJ
        WHERE
            YWPK01 = D.GHDWID
            AND YWBM = 'GYS13'
        LIMIT
            1
    ) sfcq,
    (
        SELECT
            YWPK02
        FROM
            XTXXFJ
        WHERE
            YWPK01 = D.GHDWID
            AND YWBM = 'GYS13'
        LIMIT
            1
    ) qsrq,
    (
        SELECT
            YWPK03
        FROM
            XTXXFJ
        WHERE
            YWPK01 = D.GHDWID
            AND YWBM = 'GYS13'
        LIMIT
            1
    ) jsrq,
    D.TJDWMC zrdwmc,
    D.TJDWBM zrdwbm,
    D.SFZR sfzr,
    'CXZR' ywlx,
    (
        SELECT
            COUNT(1)
        FROM
            XTGHDW_YW_ZR_ZRPSFA A,
            XTGHDW_YW_ZR_ZRPSFA_GYS B
        WHERE
            A.ZRPSFABM = B.ZRPSFABM
            AND B.GYSBM = D.DWBM
            AND A.SHBZ = '2'
    ) sfps,
    (
        SELECT
            GROUP_CONCAT (X.DWMC SEPARATOR ',')
        FROM
            XTGHDW_A_FWGX F,
            XTLLDW X
        WHERE
            F.DWBM = D.DWBM
            AND X.DWBM = F.ZZJG
    ) FWGXDWMC
FROM
    XTGHDW D
WHERE
    D.SHBZ = '2'
    -- <if test=""startTime != null"">
    AND D.SHRQ >= '2024-01-01' -- #{startTime}
    -- </if>
    -- <if test=""endTime != null"">
    AND D.SHRQ < '2024-09-01' -- #{endTime}
    -- </if>
    -- <if test=""tyshxydm != null"">
    --     AND d.YYZZ = #{tyshxydm}
    -- </if>
UNION ALL
SELECT
    D.DWMC gysmc,
    D.DWBM gysbm,
    D.YYZZ tyshxydm,
    D.ZCZJ zczb,
    D.FR fddbr,
    D.DWDZ dwdz,
    (
        SELECT
            IFNULL (YWPK10, 0)
        FROM
            XTXXFJ
        WHERE
            YWPK01 = D.GHDWID
            AND YWBM = 'GYS13'
        LIMIT
            1
    ) sfcq,
    (
        SELECT
            YWPK02
        FROM
            XTXXFJ
        WHERE
            YWPK01 = D.GHDWID
            AND YWBM = 'GYS13'
        LIMIT
            1
    ) qsrq,
    (
        SELECT
            YWPK03
        FROM
            XTXXFJ
        WHERE
            YWPK01 = D.GHDWID
            AND YWBM = 'GYS13'
        LIMIT
            1
    ) jsrq,
    D.TJDWMC zrdwmc,
    D.TJDWBM zrdwbm,
    D.SFZR sfzr,
    'QY' ywlx,
    (
        SELECT
            COUNT(1)
        FROM
            XTGHDW_YW_ZR_ZRPSFA A,
            XTGHDW_YW_ZR_ZRPSFA_GYS B
        WHERE
            A.ZRPSFABM = B.ZRPSFABM
            AND B.GYSBM = D.DWBM
            AND A.SHBZ = '2'
    ) sfps,
    (
        SELECT
            GROUP_CONCAT (X.DWMC SEPARATOR ',')
        FROM
            XTGHDW_A_FWGX F,
            XTLLDW X
        WHERE
            F.DWBM = D.DWBM
            AND X.DWBM = F.ZZJG
    ) FWGXDWMC
FROM
    XTGHDW D,
    XTGHDW_YW_DA_QYSQ Q
WHERE
    Q.GYSBM = D.DWBM
    AND Q.SHBZ = '2'
    AND Q.ZBSHBZ = '0'
    -- <if test=""startTime != null"">
    AND Q.SHSJ >= '2024-01-01' -- #{startTime}
    -- </if>
    -- <if test=""endTime != null"">
    AND Q.SHSJ < '2024-09-01' --  #{endTime}
    -- </if>
    -- <if test=""tyshxydm != null"">
    --     AND d.YYZZ = #{tyshxydm}
    -- </if>