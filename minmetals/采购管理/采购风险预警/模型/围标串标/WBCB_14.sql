-- 围标串标：投标人串通投标	
-- 体征：投标人之间存在关联关系
-- 应用名称：WBCB14

drop table if exists ods_dsep_test.ADS_WBCB_14;
create table ods_dsep_test.ADS_WBCB_14
unique key(uuid) as
select
    md5(uuid()) as uuid, 
    '0' as onuse,
    cast(null as datetime) as etl_time,
    strleft(dwbm, 3) as zgqybm,
    audittime,
    project_name,
    dwmc,
    dwbm,
    yyzz,
    inviteno,
    schemecode,
    djdwmc,
    recorder_code,  -- 招标制单人编码
    recorder_desc,  -- 招标制单人名称
    invitecorpcode, -- 招标单位编码
    invitecorpdesc, -- 招标单位名称
    compare_time
from
    (
        with
            base as (
                select
                    a.schemedesc as project_name,
                    a.inviteno,
                    a.schemecode,
                    a.djdwmc,
                    a.recordercode as recorder_code, -- 招标制单人编码
                    a.recorderdesc as recorder_desc, -- 招标制单人名称
                    a.invitecorpcode as a_invitecorpcode, -- 招标单位编码
                    a.invitecorpdesc as a_invitecorpdesc, -- 招标单位名称
                    a.audittime as compare_time,
                    a.purchasemode,
                    b.sign_endtime,
                    b.audittime,
                    b.invitecorpcode as b_invitecorpcode,
                    b.invitecorpdesc as b_invitecorpdesc,
                    b.ycbz,
                    c.dwmc,
                    c.dwbm,
                    g.yyzz
                from
                    dw_ods_dsep.ods_cg_ztb_invitescheme as a
                    inner join dw_ods_dsep.ods_cg_ztb_invite as b on
                        a.inviteschemeid = b.inviteschemeid
                    inner join dw_ods_dsep.ods_cg_ztb_invitesupplier as c on 
                        a.inviteschemeid = c.inviteschemeid
                    inner join dw_ods_dsep.ods_cg_xtghdw as g on 
                        c.dwbm = g.dwbm
                where
                    b.abortinvite = '0' -- 投标文件未废标
                    and a.auditflag = '2' -- 招标文件已审核通过
            ) 
        select
            audittime,
            project_name,
            dwmc,
            dwbm,
            yyzz,
            inviteno,
            schemecode,
            djdwmc,
            recorder_code, -- 招标制单人编码
            recorder_desc, -- 招标制单人名称
            a_invitecorpcode as invitecorpcode, -- 招标单位编码
            a_invitecorpdesc as invitecorpdesc, -- 招标单位名称
            compare_time
        from
            base
        where
            purchasemode = '02' -- 邀请招标
        union all
        select
            audittime,
            project_name,
            dwmc,
            dwbm,
            yyzz,
            inviteno,
            schemecode,
            djdwmc,
            recorder_code, -- 招标制单人编码
            recorder_desc, -- 招标制单人名称
            b_invitecorpcode as invitecorpcode, -- 招标单位编码
            b_invitecorpdesc as invitecorpdesc, -- 招标单位名称
            compare_time
        from
            base
        where
            ycbz = '1' -- 招标通知已经外网发布
            and purchasemode = '01' -- 公开招标
            and sign_endtime <= now ()
    ) as main -- 报名截至



/*** 带参数抽取 ADS 示例 ***


select
    audittime,
    project_name,
    dwmc,
    dwbm,
    yyzz,
    inviteno,
    schemecode,
    djdwmc,
    recorder_code,      -- 招标制单人编码
    recorder_desc,      -- 招标制单人名称
    invitecorpcode,     -- 招标单位编码
    invitecorpdesc      -- 招标单位名称
from ads
where true 
    and compare_time >= '2024-08-01'    -- #{startDate} 
    and compare_time <= '2024-09-01'    -- #{endDate}

*****************/