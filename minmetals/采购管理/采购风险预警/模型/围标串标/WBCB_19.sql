-- 围标串标：投标人串通投标
-- 体征：同标段机器码雷同
-- 应用名称：WBCB19
-- 测试：通过

drop table if exists ods_dsep_test.ADS_WBCB_19;
create table ods_dsep_test.ADS_WBCB_19
unique key(uuid) as
select
    uuid,
    onuse,
    etl_time,
    zgqybm, -- 直管企业编码
    releasetime, -- 增量
    inviteno,
    schemedesc,
    schemecode,
    dwbm,
    dwmc,
    mac,
    hdid,
    mainbordid,
    toolid,
    cpuid,
    invitecorpcode,
    invitecorpdesc,
    djdwmc
from
    (
        with
            main as (
                select
                    o.releasetime, -- 增量
                    a.inviteno,
                    a.schemedesc,
                    a.schemecode,
                    c.dwbm,
                    c.dwmc,
                    c.mac,
                    c.hdid,
                    c.mainbordid,
                    c.toolid,
                    c.cpuid,
                    a.invitecorpcode,
                    a.invitecorpdesc,
                    a.djdwmc
                from
                    dw_ods_dsep.ods_cg_ztb_invitescheme as a
                    inner join dw_ods_dsep.ods_cg_ztb_invite as b on a.inviteschemeid = b.inviteschemeid
                    inner join dw_ods_dsep.ods_cg_ztb_bid as c on b.inviteid = c.inviteid
                    inner join dw_ods_dsep.ods_cg_ztb_bid as d on c.inviteid = d.inviteid
                    and c.mac = d.mac
                    and c.hdid = d.hdid
                    and c.mainbordid = d.mainbordid
                    and c.toolid = d.toolid
                    and c.cpuid = d.cpuid
                    inner join dw_ods_dsep.ods_cg_ztb_bidopen as o on b.inviteid = o.inviteid
                where
                    b.auditflag = '2' -- 招标通知已发布
                    and b.abortinvite = '0' -- 投标文件未废标
                    and c.mac is not null
                    and c.hdid is not null
                    and c.mainbordid is not null
                    and c.toolid is not null
                    and c.cpuid is not null
                    and c.busi_releaseflag = '1' -- 投标文件已发布
                    and c.bidid <> d.bidid
                    and c.dwbm <> d.dwbm
                    and c.busi_releaseflag = '1'
                    and d.busi_releaseflag = '1' -- 投标文件已发布
                    and d.mac is not null
                    and d.hdid is not null
                    and d.mainbordid is not null
                    and d.toolid is not null
                    and d.cpuid is not null
                    and o.abortinvite = '0' -- 投标文件未废标
                    and o.releaseflag = '1' -- 开标登记已发布
            ),
            ads as (
                select
                    md5 (
                        concat_ws (
                            '-',
                            releasetime,
                            inviteno,
                            schemecode,
                            dwbm,
                            dwmc,
                            mac,
                            hdid,
                            mainbordid,
                            toolid,
                            cpuid,
                            invitecorpcode,
                            invitecorpdesc,
                            djdwmc
                        )
                    ) as uuid,
                    '0' as onuse,
                    cast(null as datetime) as etl_time,
                    strleft (dwbm, 3) as zgqybm, -- 直管企业编码
                    main.*
                from
                    main
            ),
            test as (
                select distinct
                    dwbm,
                    dwmc,
                    inviteno,
                    schemedesc,
                    schemecode,
                    mac,
                    hdid,
                    mainbordid,
                    toolid,
                    cpuid,
                    invitecorpcode,
                    invitecorpdesc,
                    djdwmc
                from
                    ads
                where
                    releasetime >= '2024-01-01' -- #{startdate}
                    and releasetime < '2024-09-01' -- #{enddate}
                order by
                    mac,
                    inviteno
            )
        select
            *
        from
            ads
    ) as ads




-- Doris test set
drop table if exists ods_dsep_test.TEST_WBCB_19;
create table ods_dsep_test.TEST_WBCB_19
duplicate key(dwbm) 
as
select * from test




-- MySQL test set
SELECT
    T.INVITENO,
    T.SCHEMEDESC,
    T.DWBM,
    T.DWMC,
    T.MAC,
    T.HDID,
    T.MAINBORDID,
    T.TOOLID,
    T.CPUID,
    T.INVITECORPCODE,
    T.INVITECORPDESC,
    T.DJDWMC
FROM
    (
        SELECT DISTINCT
            A.INVITENO,
            A.SCHEMEDESC,
            C.DWBM,
            C.DWMC,
            C.MAC,
            C.HDID,
            C.MAINBORDID,
            C.TOOLID,
            C.CPUID,
            A.INVITECORPCODE,
            A.INVITECORPDESC,
            A.DJDWMC
        FROM
            ZTB_INVITESCHEME A,
            ZTB_INVITE B,
            ZTB_BID C,
            ZTB_BID D,
            ztb_bidopen O
        WHERE
            A.INVITESCHEMEID = B.INVITESCHEMEID
            AND B.INVITEID = C.INVITEID
            AND B.AUDITFLAG = '2'
            AND B.ABORTINVITE = '0'
            AND C.MAC IS NOT NULL
            AND C.HDID IS NOT NULL
            AND C.MAINBORDID IS NOT NULL
            AND C.TOOLID IS NOT NULL
            AND C.CPUID IS NOT NULL
            AND C.BUSI_RELEASEFLAG = '1'
            AND D.BUSI_RELEASEFLAG = '1'
            AND D.MAC IS NOT NULL
            AND D.HDID IS NOT NULL
            AND D.MAINBORDID IS NOT NULL
            AND D.TOOLID IS NOT NULL
            AND D.CPUID IS NOT NULL
            AND C.INVITEID = D.INVITEID
            AND C.BIDID <> D.BIDID
            AND C.DWBM <> D.DWBM
            AND C.MAC = D.MAC
            AND C.HDID = D.HDID
            AND C.MAINBORDID = D.MAINBORDID
            AND C.TOOLID = D.TOOLID
            AND C.CPUID = D.CPUID
            AND C.BUSI_RELEASEFLAG = '1'
            AND B.INVITEID = O.INVITEID
            AND B.ABORTINVITE = '0'
            AND O.ABORTINVITE = '0'
            AND O.RELEASEFLAG = '1'
            AND O.RELEASETIME >= '2024-01-01'
            AND O.RELEASETIME < '2024-09-01'
    ) T
ORDER BY
    T.MAC,
    T.INVITENO




-- test
with
    test as (
        select
            md5 (
                concat_ws (
                    '-',
                    dwbm,
                    dwmc,
                    inviteno,
                    schemedesc,
                    schemecode,
                    mac,
                    hdid,
                    mainbordid,
                    toolid,
                    cpuid,
                    invitecorpcode,
                    invitecorpdesc,
                    djdwmc
                )
            ) as rh
        from
            TEST_WBCB_19
    ),
    mcc as (
        select
            md5 (
                concat_ws (
                    '-',
                    dwbm,
                    dwmc,
                    inviteno,
                    schemedesc,
                    schemecode,
                    mac,
                    hdid,
                    mainbordid,
                    toolid,
                    cpuid,
                    invitecorpcode,
                    invitecorpdesc,
                    djdwmc
                )
            ) as rh
        from
            TEST_WBCB_19
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