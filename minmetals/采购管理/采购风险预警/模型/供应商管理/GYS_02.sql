-- 供应商管理：违规注册
-- 体征：重复注册
-- 应用名称：GYS02

drop table if exists ods_dsep_test.ADS_GYS_02;
create table ods_dsep_test.ADS_GYS_02
unique key(uuid) as 



-- MySQL test set
SELECT
    d.DWMC gysmc,
    d.DWBM gysbm,
    d.YYZZ tyshxydm,
    d.ZCZJ zczb,
    d.fr fddbr,
    d.TJDWMC zrdwmc,
    d.TJDWBM zrdwbm,
    d.SFZR sfzr,
    'ZK' ywlx,
    (
        select
            GROUP_CONCAT (x.dwmc Separator ',')
        from
            xtghdw_a_fwgx f,
            xtlldw x
        where
            f.dwbm = d.dwbm
            and x.DWBM = f.ZZJG
    ) fwgxdwmc
FROM
    xtghdw d
WHERE
    D.SHBZ = '2'
    AND D.SFZR = '1'
    AND D.TYBZ = '0'
    AND D.TCBZ = '0'
    AND NOT EXISTS (
        SELECT
            1
        FROM
            ZTB_JK_YJXX B
        WHERE
            B.ZBBM = D.GHDWID
            AND B.YJLXID = 'GYS03'
            AND B.ZT = '1'
    )

