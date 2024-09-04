-- 围标串标：不同投标单位实际控制人为同一人
-- 体征：同标段不同单位联系人雷同
-- 应用名称：WBCB21

drop table if exists ods_dsep_test.ADS_WBCB_21;
create table ods_dsep_test.ADS_WBCB_21
unique key(uuid) as
select
    md5 (uuid ()) as uuid,
    '0' as onuse,
    cast(null as datetime) as etl_time,
    strleft (c.dwbm, 3) as zgqybm, -- 直管企业编码
    o.releasetime, -- 增量
    e.schemedesc,
    e.inviteno, -- 招标编码
    e.djdwmc, -- 单据单位名称
    c.dwmc,
    c.bidid as dwmc_id,
    g.lxr, -- 联系人
    g.lxrsfz, -- 档案联系人身份证号
    c.linkman, -- 被授权人
    c.email,
    c.mobile,
    c.tel,
    d.invitecorpcode, -- 采购单位编码
    d.invitecorpdesc -- 采购单位名称
from
    dw_ods_dsep.ods_cg_ztb_bid as c
    inner join dw_ods_dsep.ods_cg_ztb_invite as d on c.inviteid = d.inviteid
    inner join dw_ods_dsep.ods_cg_ztb_invitescheme as e on e.inviteschemeid = d.inviteschemeid
    inner join dw_ods_dsep.ods_cg_xtghdw as g on c.dwbm = g.dwbm
    inner join dw_ods_dsep.ods_cg_ztb_bidopen as o on d.inviteid = o.inviteid
where
    d.auditflag = '2' -- 招标通知已发布
    and d.abortinvite = '0' -- 投标文件未废标
    and o.abortinvite = '0' -- 排除开标登记为废标的
    and o.releaseflag = '1' -- 开标登记已发布




/*** 带参数抽取 ADS 示例 ***

select
    schemedesc,
    inviteno, 
    djdwmc, 
    dwmc,
    bidid as dwmc_id,
    lxr, 
    lxrsfz, 
    linkman,
    email,
    mobile,
    tel,
    invitecorpcode, 
    invitecorpdesc 
from ADS_WBCB_21
where true
    and releasetime >= '2024-08-01'   -- #{startDate}
    and releasetime < '2024-09-01'    -- #{endDate}

******************/






























------------------

