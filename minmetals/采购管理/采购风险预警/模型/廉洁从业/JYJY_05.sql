-- 廉洁从业：利益输送
-- 体征：企业职工投资关联关系企业参加本单位业务
-- 应用名称：JYJY02

drop table if exists ods_dsep_test.ADS_JYJY_05;
create table ods_dsep_test.ADS_JYJY_05
unique key(uuid) as



-- Doris test set
drop table if exists ods_dsep_test.TEST_JYJY_05;
create table ods_dsep_test.TEST_JYJY_05
duplicate key(zzppbm) 
as
select * from test




-- MySQL test set
SELECT
    A.INVITENO,
    A.SCHEMEDESC as project_name,
    A.SCHEMECODE,
    G.DWMC dwmc,
    G.LXR,
    G.LXRSFZ,
    G.FR,
    G.FRSFZ,
    G.YYZZ yyzz,
    P.UNAME, -- 采购单位监督人编码
    P.UMEMO, -- 采购单位监督人名称
    B.INVITECORPCODE, -- 招标单位编码
    L.DWMC as three_dwmc, -- 三级直管单位名称
    B.INVITECORPDESC as djdwmc -- 招标单位名称
FROM
    ZTB_INVITESCHEME A,
    ZTB_INVITE B,
    ZTB_BID C,
    XTGHDW G,
    PURCHASE_LIBRARIANS P,
    XTLLDW L
WHERE
    G.TCBZ = '0'
    AND L.DWBM = LEFT (B.INVITECORPCODE, 6)
    AND A.INVITESCHEMEID = B.INVITESCHEMEID
    AND B.INVITEID = C.INVITEID
    AND C.DWBM = G.DWBM
    AND P.ORGID = B.INVITECORPCODE
    AND C.BUSI_RELEASEFLAG = '1'
    AND B.ABORTINVITE = '0'
    AND B.AUDITFLAG = '2'
    -- <if test="dwmcs != null and dwmcs.size() != 0">
    --     AND G.DWMC in
    --     <foreach collection="dwmcs" item="item" open="(" separator="," close=")">
    --         #{item}
    --     </foreach>
    -- </if>
    AND B.AUDITTIME >= '2024-01-01' -- #{startDate}
    and B.AUDITTIME < '2024-09-01'