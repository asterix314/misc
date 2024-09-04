-- 供应商管理
-- 要素：违规使用
-- 体征：黑名单关联企业参与采购业务
-- 应用名称：GYS10

drop table if exists ods_dsep_test.ADS_GYS_10;
create table ods_dsep_test.ADS_GYS_10
unique key(uuid) as 
select distinct
    md5(concat_ws('-', type, inviteno, dwbm, cgdwbm, compare_time)) as uuid,
    '0' as onuse,
    cast(null as datetime) as etl_time,
    strleft(dwbm, 3) as zgqybm,
    type,
    inviteno,
    invitedesc,
    dwbm,
    dwmc,
    cgdwbm,
    cgdwmc,
    compare_time,
    tyshxydm,
    frsfz,
    fr
from
    (
        with
            ac as (
                select
                    a.dwbm,
                    a.dwmc,
                    a.busi_releasetime,
                    a.busi_releaseflag,
                    c.inviteno,
                    c.inviteid,
                    c.invitedesc,
                    c.inviteschemeid,
                    c.invitecorpcode as cgdwbm,
                    c.invitecorpdesc as cgdwmc
                from
                    dw_ods_dsep.ods_cg_ztb_bid as a
                    inner join dw_ods_dsep.ods_cg_ztb_invite as c on 
                        a.inviteid = c.inviteid
            ),
            main as (
                select
                    'zb' as type,
                    ac.inviteno,
                    ac.invitedesc,
                    ac.dwbm,
                    ac.dwmc,
                    ac.cgdwbm,
                    ac.cgdwmc,
                    ac.busi_releasetime as compare_time
                from
                    ac
                    inner join dw_ods_dsep.ods_cg_ztb_invitescheme as b on 
                        b.inviteschemeid = ac.inviteschemeid
                where
                    ac.busi_releaseflag = '1'
                union all
                select
                    'zb' as type,
                    ac.inviteno,
                    ac.invitedesc,
                    ac.dwbm,
                    ac.dwmc,
                    ac.cgdwbm,
                    ac.cgdwmc,
                    b.audittime as compare_time
                from
                    ac
                    inner join dw_ods_dsep.ods_cg_ztb_busiaudit as b on 
                        b.inviteid = ac.inviteid
                where
                    b.auditflag = '2'
                union all
                select
                    'zb' as type,
                    ac.inviteno,
                    ac.invitedesc,
                    ac.dwbm,
                    ac.dwmc,
                    ac.cgdwbm,
                    ac.cgdwmc,
                    b.audittime as compare_time
                from
                    ac
                    inner join dw_ods_dsep.ods_cg_ztb_integrateaudit as b on 
                        b.inviteid = ac.inviteid
                where
                    b.auditflag = '2'
                union all
                select
                    'ht' as type,
                    htbm,
                    htmc,
                    dwbm,
                    dwmc,
                    xfdm,
                    xfmc,
                    sprq as compare_time
                from
                    dw_ods_dsep.ods_cg_cght
                where
                    swbz = '2'
            )
        select
            main.*,
            g.yyzz as tyshxydm,
            g.frsfz,
            g.fr
        from
            main
            inner join dw_ods_dsep.ods_cg_xtghdw as g on 
                g.dwbm = main.dwbm
    ) as ads






/*** 带参数抽取 ADS 示例 ***
        
select distinct 
    type,
    inviteno,
    invitedesc,
    dwbm,
    dwmc,
    cgdwbm,
    cgdwmc,
    tyshxydm,
    frsfz,
    fr
from ADS_GYS_10
where true 
   and compare_time >= '2024-08-01' -- <if test=startTime != null>
   and compare_time <= '2024-09-01' -- <if test=endTime != null>
   and tyshxydm = 'xxxx'            -- <if test=tyshxydm!=null>

******/