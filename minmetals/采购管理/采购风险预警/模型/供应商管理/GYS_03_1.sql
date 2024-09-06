-- 供应商管理：违规注册
-- 体征：黑名单企业变相入库
-- 应用名称：GYS03

drop table if exists ods_dsep_test.ADS_GYS_03_1;
create table ods_dsep_test.ADS_GYS_03_1
unique key(uuid) as 



-- MySQL test set
SELECT
    T.FR fr,
    T.DWMC gysmc,
    t.frsfz,
    T.YYZZ tyshxydm,
    TJDWBM zrdwbm
FROM
    xtghdw T
WHERE
    T.TCBZ = '1'
    AND EXISTS (
        SELECT
            1
        FROM
            XTGHDW_YW_DA_TCSQ Q
        WHERE
            T.DWBM = Q.GYSBM
    )
    -- <if test=""startTime!=null"">
    AND SHRQ >= '2024-01-01' -- #{startTime}
    -- </if>
    -- <if test=""endTime!=null"">
    AND SHRQ < '2024-09-01' -- #{endTime}
    -- </if>
    -- <if test=""tyshxydm!=null"">
    -- AND T.YYZZ= #{tyshxydm}
    -- </if>