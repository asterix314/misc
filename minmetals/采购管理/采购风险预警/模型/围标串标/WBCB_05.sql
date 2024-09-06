-- 围标串标：评标发现的异常现象
-- 体征：投标人有严重违法失信记录
-- 应用名称：WBCB05

drop table if exists ods_dsep_test.ADS_WBCB_05;
create table ods_dsep_test.ADS_WBCB_05
unique key(uuid) as
select
    md5 (uuid ()) as uuid,
    '0' as onuse,
    cast(null as datetime) as etl_time,
    strleft (dwbm, 3) as zgqybm,
    yyzz,
    schemedesc,
    dwmc,
    dwbm,
    inviteschemeid,
    inviteno,
    schemecode,
    recordercode, -- 招标制单人编码
    recorderdesc, -- 招标制单人名称
    invitecorpcode as invitecorpdesc, -- 招标单位名称 (为配合java代码的逻辑就是反的)
    invitecorpdesc as invitecorpcode, -- 招标单位编码 (为配合java代码的逻辑就是反的)
    compare_time
from
    (
        with
            main as (
                select
                    e.schemedesc,
                    c.dwmc,
                    c.dwbm,
                    e.inviteschemeid,
                    e.inviteno,
                    e.schemecode,
                    e.recordercode, -- 招标制单人编码
                    e.recorderdesc, -- 招标制单人名称
                    e.invitecorpcode, -- 招标单位编码
                    e.invitecorpdesc, -- 招标单位名称
                    cm.approvedate as compare_time
                from
                    dw_ods_dsep.ods_cg_ztb_invitesupplier as c
                    inner join dw_ods_dsep.ods_cg_ztb_invitescheme as e on c.inviteschemeid = e.inviteschemeid
                    inner join dw_ods_dsep.ods_cg_ztb_invite as d on e.inviteschemeid = d.inviteschemeid
                    inner join dw_ods_dsep.ods_cg_t_audit_comment as cm on e.inviteschemeid = cm.billid
                where
                    e.auditflag > '0'
                    and e.purchasemode = '02'
                    and cm.tablename = 'ZTB_INVITESCHEME'
                    and cm.type = '0'
                union all
                select
                    e.schemedesc,
                    c.dwmc,
                    c.dwbm,
                    e.inviteschemeid,
                    e.inviteno,
                    e.schemecode,
                    e.recordercode, -- 招标制单人编码
                    e.recorderdesc, -- 招标制单人名称
                    e.invitecorpcode, -- 招标单位编码
                    e.invitecorpdesc, -- 招标单位名称
                    c.audittime as compare_time
                from
                    dw_ods_dsep.ods_cg_ztb_bidapply as c
                    inner join dw_ods_dsep.ods_cg_ztb_invite as d on 
                        c.inviteid = d.inviteid
                    inner join dw_ods_dsep.ods_cg_ztb_invitescheme as e on 
                        e.inviteschemeid = d.inviteschemeid
                where
                    c.auditflag = '2'
                    and e.purchasemode = '01'
            )
        select
            c.yyzz,
            main.*
        from
            main
            left join dw_ods_dsep.ods_cg_xtghdw as c on main.dwbm = c.dwbm
    ) as ads




/*** 带参数抽取 ADS 示例 ***

select distinct
    inviteschemeid,                 -- 招标方案主键
    inviteno,                       -- 招标编码
    schemecode,                     -- 招标编号
    schemedesc,                     -- 项目名称
    dwmc as suppliername,           -- 投标供应商名称
    recordercode,                   -- 招标制单人编码
    recorderdesc,                   -- 招标制单人名称
    invitecorpcode as djdwbm,       -- 招标单位编码
    invitecorpdesc as tendereename, -- 招标单位名称
    yyzz as creditcode              -- 统一社会信用代码
from ADS_WBCB_05
where true
    and compare_time >= '2024-08-01' -- <if test=starttime != null>
    and compare_time <= '2024-10-01' -- <if test=endtime != null>
        
********/

