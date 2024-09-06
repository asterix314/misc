-- GYS09 TEST


-- 旧 SQL
-- 583500
select
    count(1)
from
    (
        SELECT
            d.DWMC gysmc,
            d.YYZZ tyshxydm,
            d.TJDWBM zrdwbm,
            s.INVITENO,
            s.INVITECORPDESC cgdw,
            s.SCHEMEDESC xmmc,
            case
                when d.TCBZ = '1' then '黑名单'
                when d.TYBZ = '1' then '停用'
            end gyszt,
            '停用/黑名单供应商参与投标报名' AS yy
        FROM
            xtghdw d,
            ztb_invitescheme s,
            ZTB_BIDAPPLY A
        WHERE
            A.DWBM = d.DWBM
            and A.INVITEID = s.INVITESCHEMEID
            AND A.AUDITFLAG = '2'
            -- <if test=""startTime!=null"">
            --     AND A.AUDITTIME &gt;= #{startTime}
            -- </if>
            -- <if test=""endTime!=null"">
            --     AND A.AUDITTIME &lt;= #{endTime}
            -- </if>
            -- <if test=""tyshxydm!=null"">
            --     AND d.YYZZ = #{tyshxydm}
            -- </if>
            AND (
                d.TCBZ = '1'
                or d.TYBZ = '1'
            )
        union all
        SELECT
            d.DWMC gysmc,
            d.YYZZ tyshxydm,
            d.TJDWBM zrdwbm,
            s.INVITENO,
            s.INVITECORPDESC cgdw,
            s.SCHEMEDESC xmmc,
            case
                when d.TCBZ = '1' then '黑名单'
                when d.TYBZ = '1' then '停用'
            end gyszt,
            '停用/黑名单供应商参与投标' AS yy
        FROM
            xtghdw d,
            ztb_invitescheme s,
            ZTB_BID A
        WHERE
            A.DWBM = d.DWBM
            and A.INVITEID = s.INVITESCHEMEID
            AND A.BUSI_RELEASEFLAG = '1'
            -- <if test=""startTime!=null"">
            --     AND A.BUSI_RELEASETIME &gt;= #{startTime}
            -- </if>
            -- <if test=""endTime!=null"">
            --     AND A.BUSI_RELEASETIME &lt;= #{endTime}
            -- </if>
            -- <if test=""tyshxydm!=null"">
            --     AND d.YYZZ = #{tyshxydm}
            -- </if>
            AND (
                d.TCBZ = '1'
                or d.TYBZ = '1'
            )
        union all
        SELECT
            d.DWMC gysmc,
            d.YYZZ tyshxydm,
            d.TJDWBM zrdwbm,
            s.INVITENO,
            s.INVITECORPDESC cgdw,
            s.SCHEMEDESC xmmc,
            case
                when d.TCBZ = '1' then '黑名单'
                when d.TYBZ = '1' then '停用'
            end gyszt,
            '停用/黑名单供应商参与评标' AS yy
        FROM
            xtghdw d,
            ztb_invitescheme s,
            ZTB_BID A,
            ZTB_BUSIAUDITSUPP B,
            ZTB_BUSIAUDIT C
        WHERE
            A.DWBM = d.DWBM
            and A.INVITEID = s.INVITESCHEMEID
            AND A.BUSI_RELEASEFLAG = '1'
            AND B.BIDID = A.BIDID
            AND B.BUSIAUDITID = C.BUSIAUDITID
            -- <if test=""startTime!=null"">
            --     AND C.RECORDTIME &gt;= #{startTime}
            -- </if>
            -- <if test=""endTime!=null"">
            --     AND C.RECORDTIME &lt;= #{endTime}
            -- </if>
            -- <if test=""tyshxydm!=null"">
            --     AND d.YYZZ = #{tyshxydm}
            -- </if>
            AND (
                d.TCBZ = '1'
                or d.TYBZ = '1'
            )
        union all
        SELECT
            d.DWMC gysmc,
            d.YYZZ tyshxydm,
            d.TJDWBM zrdwbm,
            s.INVITENO,
            s.INVITECORPDESC cgdw,
            s.SCHEMEDESC xmmc,
            case
                when d.TCBZ = '1' then '黑名单'
                when d.TYBZ = '1' then '停用'
            end gyszt,
            '停用/黑名单供应商被选为中标单位' AS yy
        FROM
            xtghdw d,
            ztb_invitescheme s,
            ZTB_BID A,
            ZTB_INTEGRATEAUDITSUPP B,
            ZTB_INTEGRATEAUDIT C
        WHERE
            A.DWBM = d.DWBM
            and A.INVITEID = s.INVITESCHEMEID
            AND A.BUSI_RELEASEFLAG = '1'
            AND B.BIDID = A.BIDID
            AND B.INTEGRATEAUDITID = C.INTEGRATEAUDITID
            AND B.AWARDFLAG = '1'
            AND C.AUDITFLAG = '2'
            -- <if test=""startTime!=null"">
            --     AND C.AUDITTIME &gt;= #{startTime}
            -- </if>
            -- <if test=""endTime!=null"">
            --     AND C.AUDITTIME &lt;= #{endTime}
            -- </if>
            -- <if test=""tyshxydm!=null"">
            --     AND d.YYZZ = #{tyshxydm}
            -- </if>
            AND (
                d.TCBZ = '1'
                or d.TYBZ = '1'
            )
        union all
        SELECT
            d.DWMC gysmc,
            d.YYZZ tyshxydm,
            d.TJDWBM zrdwbm,
            s.INVITENO,
            s.INVITECORPDESC cgdw,
            s.SCHEMEDESC xmmc,
            case
                when d.TCBZ = '1' then '黑名单'
                when d.TYBZ = '1' then '停用'
            end gyszt,
            '停用/黑名单供应商中标通知书发布' AS yy
        FROM
            xtghdw d,
            ztb_invitescheme s,
            ZTB_BID A,
            ZTB_INTEGRATEAUDITSUPP B,
            ZTB_INTEGRATEAUDIT C,
            ZBTZS Z
        WHERE
            A.DWBM = d.DWBM
            and A.INVITEID = s.INVITESCHEMEID
            AND B.BIDID = A.BIDID
            AND B.INTEGRATEAUDITID = C.INTEGRATEAUDITID
            AND B.AWARDFLAG = '1'
            AND Z.DBBM = C.AUDITNO
            AND Z.GHDWBM = D.DWBM
            AND Z.SHBZ = '2'
            -- <if test=""startTime!=null"">
            --     AND Z.SHSJ &gt;= #{startTime}
            -- </if>
            -- <if test=""endTime!=null"">
            --     AND Z.SHSJ &lt;= #{endTime}
            -- </if>
            -- <if test=""tyshxydm!=null"">
            --     AND d.YYZZ = #{tyshxydm}
            -- </if>
            AND (
                d.TCBZ = '1'
                or d.TYBZ = '1'
            )
    ) as ads_mysql

    
    
    
-- 新 SQL
-- 583500
select
    count(1)
from
    (
        select
            md5 (
                concat_ws (
                    '-',
                    dwbm,
                    zrdwbm,
                    gyszt,
                    inviteno,
                    cgdw,
                    xmmc,
                    yy,
                    compare_time
                )
            ) as uuid,
            '0' as onuse,
            cast(null as datetime) as etl_time,
            left(dwbm, 3) as zgqybm,
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
                select
                    d.*,
                    s.inviteno,
                    s.invitecorpdesc as cgdw,
                    s.schemedesc as xmmc,
                    '停用/黑名单供应商参与投标报名' as yy, -- 原因1
                    a.audittime as compare_time
                from
                    (
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
                            xtghdw
                        where
                            tcbz = '1'
                            or tybz = '1'
                    ) as d
                    inner join ztb_bidapply as a on a.dwbm = d.dwbm
                    inner join ztb_invitescheme as s on a.inviteid = s.inviteschemeid
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
                    (
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
                            xtghdw
                        where
                            tcbz = '1'
                            or tybz = '1'
                    ) as d
                    inner join ztb_bid as a on a.dwbm = d.dwbm
                    inner join ztb_invitescheme as s on a.inviteid = s.inviteschemeid
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
                    (
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
                            xtghdw
                        where
                            tcbz = '1'
                            or tybz = '1'
                    ) as d
                    inner join ztb_bid as a on a.dwbm = d.dwbm
                    inner join ztb_invitescheme as s on a.inviteid = s.inviteschemeid
                    inner join ztb_busiauditsupp as b on b.bidid = a.bidid
                    inner join ztb_busiaudit as c on b.busiauditid = c.busiauditid
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
                    (
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
                            xtghdw
                        where
                            tcbz = '1'
                            or tybz = '1'
                    ) as d
                    inner join ztb_bid as a on a.dwbm = d.dwbm
                    inner join ztb_invitescheme as s on a.inviteid = s.inviteschemeid
                    inner join ztb_integrateauditsupp as b on b.bidid = a.bidid
                    inner join ztb_integrateaudit as c on b.integrateauditid = c.integrateauditid
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
                    (
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
                            xtghdw
                        where
                            tcbz = '1'
                            or tybz = '1'
                    ) as d
                    inner join ztb_bid as a on a.dwbm = d.dwbm
                    inner join ztb_invitescheme as s on a.inviteid = s.inviteschemeid
                    inner join ztb_integrateauditsupp as b on b.bidid = a.bidid
                    inner join ztb_integrateaudit as c on b.integrateauditid = c.integrateauditid
                    inner join zbtzs as z on z.dbbm = c.auditno
                    and z.ghdwbm = d.dwbm
                where
                    b.awardflag = '1'
                    and z.shbz = '2'
            ) as ads
    ) as T