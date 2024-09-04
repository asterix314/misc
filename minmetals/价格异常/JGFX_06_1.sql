-- 价格异常：采购价格偏离市场
-- 体征：螺纹、线材、圆钢预中标价格偏离市场价30-200元/吨
-- 应用名称：JGFX06
-- 测试：通过

drop table if exists ods_dsep_test.ADS_JGFX_06_1;
create table ods_dsep_test.ADS_JGFX_06_1
unique key(uuid) as
select
    uuid,
    onuse,
    etl_time,
    zgqybm,
    zzppbm,
    zzppmc,
    wsjgrq,
    city,
    dj,
    dwmc,
    sprq,
    inviteno,
    schemecode,
    schemedesc,
    djdwbm,
    djdwmc,
    recorderdesc,
    recordercode,
    invitecorpdesc,
    wzmc,
    wzbm,
    ggxh,
    cz
from
    (
        with
            main as (
                select
                    a.zzppbm,
                    a.zzppmc,
                    a.wsjgrq,
                    a.scbm as city,
                    a.dj,
                    b.dwbm,
                    b.dwmc,
                    b.sprq,
                    c.inviteno,
                    c.schemecode,
                    c.schemedesc,
                    c.djdwbm,
                    c.djdwmc,
                    c.recorderdesc,
                    c.recordercode,
                    c.invitecorpdesc,
                    d.wzmc,
                    d.wzbm,
                    d.ggxh,
                    d.cz
                from
                    dw_ods_dsep.ods_cg_cghtmxmx as a
                    inner join dw_ods_dsep.ods_cg_cght as b on a.htbm = b.htbm
                    inner join dw_ods_dsep.ods_cg_ztb_invitescheme as c on a.xjbm = c.inviteschemeid
                    inner join dw_ods_dsep.ods_cg_dz_wzbm_saidi as d on d.wzbm = a.wzbm
                where
                    b.swbz = '2'
                    and a.scbm is not null
                    and a.wsjgrq is not null
            ),
            ads as (
                select
                    md5 (
                        concat_ws (
                            '-',
                            zzppbm,
                            zzppmc,
                            wsjgrq,
                            city,
                            dj,
                            dwbm,
                            dwmc,
                            sprq,
                            inviteno,
                            schemecode,
                            schemedesc,
                            djdwbm,
                            djdwmc,
                            recorderdesc,
                            recordercode,
                            invitecorpdesc,
                            wzmc,
                            wzbm,
                            ggxh,
                            cz
                        )
                    ) as uuid,
                    '0' as onuse,
                    cast(null as datetime) as etl_time,
                    strleft (dwbm, 3) as zgqybm,
                    main.*
                from
                    main
            ),
            test as (
                select distinct
                    zzppbm,
                    zzppmc,
                    wzbm,
                    wzmc,
                    wsjgrq,
                    city,
                    dj,
                    inviteno,
                    schemecode,
                    schemedesc,
                    djdwbm,
                    djdwmc,
                    recorderdesc,
                    recordercode,
                    dwmc,
                    invitecorpdesc,
                    ggxh,
                    cz
                from
                    ads
                where
                    true
                    -- and city in ('AR-0000002360')   -- < foreach > #{ite} 
                    and date(sprq) between '2024-08-01' and '2024-08-31' -- #{startTime}
            )
        select
            *
        from
            ads
    ) as ads


-- Doris test set
drop table if exists ods_dsep_test.TEST_JGFX_06_01;
create table ods_dsep_test.TEST_JGFX_06_01
duplicate key(zzppbm) 
as
select * from test




-- MySQL test set
SELECT DISTINCT
    a.zzppbm zzppbm,
    a.zzppmc zzppmc,
    D.WZBM wzbm,
    a.WSJGRQ wsjgrq,
    A.SCBM city,
    A.DJ dj,
    C.INVITENO inviteno,
    C.schemecode schemecode,
    C.SCHEMEDESC schemedesc,
    C.DJDWBM djdwbm,
    C.DJDWMC djdwmc,
    C.RECORDERDESC recorderDesc,
    C.RECORDERCODE recorderCode,
    B.DWMC dwmc,
    C.INVITECORPDESC invitecorpdesc,
    D.wzmc,
    D.ggxh,
    D.cz
FROM
    CGHTMXMX A,
    CGHT B,
    ZTB_INVITESCHEME C,
    DZ_WZBM_SAIDI D
WHERE
    CAST(A.XJBM AS SIGNED INTEGER) = C.INVITESCHEMEID
    AND A.HTBM = B.HTBM
    AND B.SWBZ = '2'
    AND A.SCBM IS NOT NULL
    AND a.WSJGRQ IS NOT NULL
    AND D.WZBM = A.WZBM
    AND D.WZBM = A.WZBM
    AND D.WZBM = A.WZBM
    --  AND D.wzbm IN < foreach collection = ""wzset"" item = ""ite"" OPEN = ""("" CLOSE = "")"" SEPARATOR = "","" > #{ite}
    --  </ foreach > 
    AND DATE (B.SPRQ) between '2024-08-01' and '2024-08-31' -- #{startTime}




-- test
with
    test as (
        select
            md5 (
                concat_ws (
                    '-',
                    zzppbm,
                    zzppmc,
                    wzbm,
                    wzmc,
                    wsjgrq,
                    city,
                    dj,
                    inviteno,
                    schemecode,
                    schemedesc,
                    djdwbm,
                    djdwmc,
                    recorderdesc,
                    recordercode,
                    dwmc,
                    invitecorpdesc,
                    ggxh,
                    cz
                )
            ) as rh
        from
            TEST_JGFX_06_01
    ),
    mcc as (
        select
            md5 (
                concat_ws (
                    '-',
                    zzppbm,
                    zzppmc,
                    wzbm,
                    wzmc,
                    wsjgrq,
                    city,
                    dj,
                    inviteno,
                    schemecode,
                    schemedesc,
                    djdwbm,
                    djdwmc,
                    recorderdesc,
                    recordercode,
                    dwmc,
                    invitecorpdesc,
                    ggxh,
                    cz
                )
            ) as rh
        from
            MCC_JGFX_06_01
    )
select
    test.rh as test,
    mcc.rh as mcc
from
    test
    full join mcc using (rh)
where
    test.rh is null
    or mcc.rh is null