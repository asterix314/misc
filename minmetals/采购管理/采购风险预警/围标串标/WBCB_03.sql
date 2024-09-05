-- 围标串标：投标行为异常
-- 体征：投标文件上传间隔异常
-- 应用名称：WBCB03

drop table if exists ods_dsep_test.ADS_WBCB_03;
create table ods_dsep_test.ADS_WBCB_03
unique key(uuid) as 
select
    md5 (uuid ()) as uuid,
    '0' as onuse,
    cast(null as datetime) as etl_time,
    strleft (c.dwbm, 3) as zgqybm, -- 直管企业编码
    a.schemedesc as projectname,
    a.inviteno as inviteno,
    a.schemecode,
    a.djdwmc as djdwmc,
    a.recordercode, -- 招标制单人编码
    a.recorderdesc, -- 招标制单人名称
    b.invitecorpcode, -- 招标单位编码
    b.invitecorpdesc, -- 招标单位名称
    b.audittime,
    c.busi_releasetime,
    c.dwmc as dwmc,
    c.dwbm,
    date_format (c.busi_releasetime, '%Y-%m-%d %H:%i:%s') as submittime
from
    dw_ods_dsep.ods_cg_ztb_invitescheme as a
    inner join dw_ods_dsep.ods_cg_ztb_invite as b on a.inviteschemeid = b.inviteschemeid
    inner join dw_ods_dsep.ods_cg_ztb_bid as c on b.inviteid = c.inviteid
where
    b.auditflag = '2'
    and b.abortinvite = '0'
    and c.busi_releaseflag = '1'
    and hour (c.busi_releasetime) not between 5 and 21
    and exists (
        select 1 
        from dw_ods_dsep.ods_cg_ztb_bid as d 
        where 
            d.inviteid = c.inviteid
            and d.bidid != c.bidid
            and d.busi_releaseflag = '1'
            and hour(d.busi_releasetime) not between 5 and 21
            and abs(timestampdiff(hour, d.busi_releasetime, c.busi_releasetime)) < 1)




/*** 带参数抽取 ADS 示例 ***

select
    projectname,
    dwmc,
    submittime,
    inviteno,
    schemecode,
    djdwmc,
    recordercode,     -- 招标制单人编码
    recorderdesc,     -- 招标制单人名称
    invitecorpcode,   -- 招标单位编码
    invitecorpdesc    -- 招标单位名称
from ads
where 
    audittime >= '2024-08-01' -- #{starttime}
order by inviteno, busi_releasetime

********/