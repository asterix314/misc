-- 围标串标：投标人串通投标
-- 体征：同标段IP地址雷同
-- 应用名称：WBCB23

drop table if exists ods_dsep_test.ADS_WBCB_23;
create table ods_dsep_test.ADS_WBCB_23
unique key(uuid) as 
select
    md5 (uuid ()) as uuid,
    '0' as onuse,
    cast(null as datetime) as etl_time,
    strleft (c.dwbm, 3) as zgqybm, -- 直管企业编码
    o.releasetime, -- 增量
    a.schemedesc,
    c.jmip,
    c.ip as ip,
    d.ip as downloadip,
    a.inviteno,
    a.schemecode,
    c.dwmc dwmc,
    a.invitecorpcode,
    a.djdwmc,
    a.djdwbm,
    a.invitecorpdesc -- 采购单位名称
from
    dw_ods_dsep.ods_cg_ztb_invitescheme as a
    inner join dw_ods_dsep.ods_cg_ztb_invite as b on 
        a.inviteschemeid = b.inviteschemeid
    inner join dw_ods_dsep.ods_cg_ztb_bid as c on 
        b.inviteid = c.inviteid
    inner join dw_ods_dsep.ods_cg_ztb_invitescheme_download as d on 
        d.inviteschemeid = a.inviteschemeid
        and d.gysdwbm = c.dwbm
    inner join dw_ods_dsep.ods_cg_ztb_bidopen as o on
        b.inviteid = o.inviteid
where
    b.auditflag = '2' -- 招标通知已发布
    and c.busi_releaseflag = '1' -- 投标文件已发布
    and b.abortinvite = '0' -- 投标文件未废标
    and o.abortinvite = '0' -- 排除开标登记未废标的
    and o.releaseflag = '1' -- 开标登记已发布


/*** 带参数抽取 ADS 示例 ***

select distinct
    schemedesc,
    jmip,
    ip,
    downloadip,
    inviteno,
    schemecode,
    dwmc,
    invitecorpcode,
    djdwmc,
    djdwbm,
    invitecorpdesc -- 采购单位名称
from ads
where true
    and releasetime >= '2024-08-02' -- #{startdate}
    and releasetime < '2024-09-10' -- #{enddate}

**********************/
