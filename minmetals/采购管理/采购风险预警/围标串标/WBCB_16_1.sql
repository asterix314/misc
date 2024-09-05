-- 围标串标：招标人与投标人串通	
-- 体征：供应商在特定采购单位的中标率极高
-- 应用名称：WBCB16

drop table if exists ods_dsep_test.ADS_WBCB_16_1;
create table ods_dsep_test.ADS_WBCB_16_1
unique key(uuid) as
select
    md5(uuid()) as uuid, 
    '0' as onuse, 
    cast(null as datetime) as etl_time,
    substring(dwbm, 1, 3) as zgqybm,
    audittime,          -- 增量
    supplier_name,      -- 投标供应商名称
    schemedesc,         -- 项目名称
    djdwbm,             -- 招标制单位编码
    inviteschemeid,     -- 招标方案主键
    inviteno,           -- 招标编码
    schemecode,         -- 招标编号
    tenderee_name       -- 招标人名称
from (
    select
        a.audittime,
        c.dwmc as supplier_name,
        e.schemedesc,
        e.invitecorpcode as djdwbm,
        e.inviteschemeid,
        e.inviteno,
        e.schemecode,
        x.dwmc as tenderee_name,
        x.dwbm 
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
        left join dw_ods_dsep.ods_cg_xtlldw as x on
            x.dwbm = e.invitecorpcode 
    where
        a.auditflag = '2'
        and c.busi_releaseflag = '1'
        and b.awardflag = '1') as main
        

/*** 带参数抽取 ADS 示例 ***


select 
    any_value(inviteschemeid) as inviteschemeid, 
    any_value(inviteno) as inviteno, 
    any_value(schemecode) as schemecode, 
    any_value(schemedesc) as schemedesc, 
    tenderee_name, 
    supplier_name, 
    any_value(djdwbm) as djdwbm, 
    count(1) as "count" -- 中标次数
from ads_wbcb_16_1
where audittime >= '2024-08-21'  -- #{startdate}
group by 
    tenderee_name,
    supplier_name

*************/
