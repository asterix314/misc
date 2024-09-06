-- 供应商管理
-- 要素：违规使用
-- 体征：黑名单供应商或被停用的D级供应商参与采购业务
-- 应用名称：GYS09

drop table if exists ods_dsep_test.ADS_GYS_09;
create table ods_dsep_test.ADS_GYS_09
unique key(uuid) as
select
    md5(concat_ws('-', dwbm, zrdwbm, gyszt, inviteno, cgdw, xmmc, yy, compare_time)) as uuid, 
    '0' as onuse,
    cast(null as datetime) as etl_time,
    strleft (dwbm, 3) as zgqybm,
    dwbm,
    gysmc,
    tyshxydm,
    zrdwbm,
    gyszt,
    inviteno,
    cgdw,
    xmmc,
    yy,
    compare_time
from
    (
        with
            d as (
                select
                    dwbm,
                    dwmc as gysmc,
                    yyzz as tyshxydm,
                    tjdwbm as zrdwbm,
                    case
                        when tcbz = '1' then '黑名单'
                        when tybz = '1' then '停用'
                    end as gyszt
                from
                    dw_ods_dsep.ods_cg_xtghdw
                where
                    tcbz = '1'
                    or tybz = '1'
            )
        select
            d.*,
            s.inviteno,
            s.invitecorpdesc as cgdw,
            s.schemedesc as xmmc,
            '停用/黑名单供应商参与投标报名' as yy, -- 原因1
            a.audittime as compare_time
        from
            d
            inner join dw_ods_dsep.ods_cg_ztb_bidapply as a on a.dwbm = d.dwbm
            inner join dw_ods_dsep.ods_cg_ztb_invitescheme as s on a.inviteid = s.inviteschemeid
        where
            a.auditflag = '2'
        union all
        select
            d.*,
            s.inviteno,
            s.invitecorpdesc as cgdw,
            s.schemedesc as xmmc,
            '停用/黑名单供应商参与投标' as yy, -- 原因2
            a.busi_releasetime as compare_time
        from
            d
            inner join dw_ods_dsep.ods_cg_ztb_bid as a on a.dwbm = d.dwbm
            inner join dw_ods_dsep.ods_cg_ztb_invitescheme as s on a.inviteid = s.inviteschemeid
        where
            a.busi_releaseflag = '1'
        union all
        select
            d.*,
            s.inviteno,
            s.invitecorpdesc as cgdw,
            s.schemedesc as xmmc,
            '停用/黑名单供应商参与评标' as yy, -- 原因3
            c.recordtime as compare_time
        from
            d
            inner join dw_ods_dsep.ods_cg_ztb_bid as a on a.dwbm = d.dwbm
            inner join dw_ods_dsep.ods_cg_ztb_invitescheme as s on a.inviteid = s.inviteschemeid
            inner join dw_ods_dsep.ods_cg_ztb_busiauditsupp as b on b.bidid = a.bidid
            inner join dw_ods_dsep.ods_cg_ztb_busiaudit as c on b.busiauditid = c.busiauditid
        where
            a.busi_releaseflag = '1'
        union all
        select
            d.*,
            s.inviteno,
            s.invitecorpdesc as cgdw,
            s.schemedesc as xmmc,
            '停用/黑名单供应商被选为中标单位' as yy, -- 原因4
            c.audittime as compare_time
        from
            d
            inner join dw_ods_dsep.ods_cg_ztb_bid as a on a.dwbm = d.dwbm
            inner join dw_ods_dsep.ods_cg_ztb_invitescheme as s on a.inviteid = s.inviteschemeid
            inner join dw_ods_dsep.ods_cg_ztb_integrateauditsupp as b on b.bidid = a.bidid
            inner join dw_ods_dsep.ods_cg_ztb_integrateaudit as c on b.integrateauditid = c.integrateauditid
        where
            a.busi_releaseflag = '1'
            and b.awardflag = '1'
            and c.auditflag = '2'
        union all
        select
            d.*,
            s.inviteno,
            s.invitecorpdesc as cgdw,
            s.schemedesc as xmmc,
            '停用/黑名单供应商中标通知书发布' as yy, -- 原因5
            z.shsj as compare_time
        from
            d
            inner join dw_ods_dsep.ods_cg_ztb_bid as a on a.dwbm = d.dwbm
            inner join dw_ods_dsep.ods_cg_ztb_invitescheme as s on a.inviteid = s.inviteschemeid
            inner join dw_ods_dsep.ods_cg_ztb_integrateauditsupp as b on b.bidid = a.bidid
            inner join dw_ods_dsep.ods_cg_ztb_integrateaudit as c on b.integrateauditid = c.integrateauditid
            inner join dw_ods_dsep.ods_cg_zbtzs as z on z.dbbm = c.auditno
            and z.ghdwbm = d.dwbm
        where
            b.awardflag = '1'
            and z.shbz = '2'
    ) as ads




/*** 带参数抽取 ADS 示例 ***

select 
    gysmc,
    tyshxydm,
    zrdwbm,
    inviteno,
    cgdw,
    xmmc,
    yy
from ADS_GYS_09
where true
   and compare_time >= '2024-08-01' -- <if test=startTime != null>
   and compare_time <= '2024-09-01' -- <if test=endTime != null>
   and tyshxydm = 'xxxx'            -- <if test=tyshxydm!=null>

********/
















