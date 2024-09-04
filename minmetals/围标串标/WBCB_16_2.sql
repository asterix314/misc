-- 围标串标：招标人与投标人串通	
-- 体征：供应商在特定采购单位的中标率极高
-- 应用名称：WBCB16

drop table if exists ods_dsep_test.ADS_WBCB_16_2;
create table ods_dsep_test.ADS_WBCB_16_2
unique key(uuid) as
select
    md5(uuid()) as uuid, 
    '0' as onuse, 
    cast(null as datetime) as etl_time,
    strleft(x.dwbm, 3) as zgqybm,   -- 直管企业编码
    a.audittime,                    -- 增量
    c.dwmc as supplier_name,        -- 投标供应商名称
    e.schemedesc,                   -- 项目名称
    e.invitecorpcode as djdwbm,     -- 招标制单位编码
    e.invitecorpdesc as djdwmc,     -- 招标制单位名称
    e.inviteschemeid,               -- 招标方案主键
    e.inviteno,                     -- 招标编码
    e.schemecode,                   -- 招标编号
    p.uname,                        -- 采购单位监督人员编码
    p.umemo,                        -- 采购单位监督人员名称
    x.dwmc as tenderee_name         -- 招标人名称
from
    dw_ods_dsep.ods_cg_ztb_integrateaudit as a
    inner join dw_ods_dsep.ods_cg_ztb_integrateauditsupp as b on
        a.integrateauditid = b.integrateauditid
    inner join dw_ods_dsep.ods_cg_ztb_bid as c on
        b.bidid = c.bidid
    inner join dw_ods_dsep.ods_cg_ztb_invite as d on
        a.inviteid = d.inviteid
    inner join dw_ods_dsep.ods_cg_ztb_invitescheme as e on
        e.inviteschemeid = d.inviteschemeid
    inner join dw_ods_dsep.ods_cg_purchase_librarians as p on
        d.invitecorpcode = p.orgid
    left join dw_ods_dsep.ods_cg_xtlldw as x on
        x.dwbm = e.invitecorpcode 
where
    a.auditflag = '2'
    and c.busi_releaseflag = '1'

/*** 带参数抽取 ADS 示例 ***


select 
    any_value(inviteschemeid) as inviteschemeid, 
    any_value(inviteno) as inviteno, 
    any_value(schemecode) as schemecode, 
    any_value(schemedesc) as schemedesc, 
    tenderee_name, 
    supplier_name, 
    any_value(djdwbm) as djdwbm, 
    any_value(djdwmc) as djdwmc, 
    any_value(uname) as uname, 
    any_value(umemo) as umemo, 
    count(1) as "count"         -- 中标次数
from ADS_WBCB_16_2
where audittime >= '2024-08-21'  -- #{startdate}
group by 
    tenderee_name,
    supplier_name

*************/