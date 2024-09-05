-- GYS10 TEST

-- 旧 SQL
-- 583500
select
    count(1)
from
    (
        select distinct
            t.*,
            g.yyzz tyshxydm,
            g.frsfz,
            g.fr
        from
            (
                SELECT
                    'zb' type,
                    c.inviteno,
                    c.INVITEDESC,
                    A.DWBM,
                    A.DWMC,
                    c.INVITECORPCODE cgdwbm,
                    c.INVITECORPDESC cgdwmc
                FROM
                    ztb_bid A,
                    ztb_invitescheme B,
                    ztb_invite c
                WHERE
                    b.INVITESCHEMEID = c.INVITESCHEMEID
                    AND c.inviteid = a.inviteid
                    and a.BUSI_RELEASEFLAG = '1'
                    -- <if test=""startTime != null"">
                    --     and a.BUSI_RELEASETIME &gt;= #{startTime}
                    -- </if>
                    -- <if test=""endTime != null"">
                    --     and a.BUSI_RELEASETIME &lt;= #{endTime}
                    -- </if>
                union all
                SELECT
                    'zb' type,
                    c.inviteno,
                    c.INVITEDESC,
                    A.DWBM,
                    A.DWMC,
                    c.INVITECORPCODE cgdwbm,
                    c.INVITECORPDESC cgdwmc
                FROM
                    ztb_bid A,
                    ztb_busiaudit B,
                    ztb_invite c
                WHERE
                    b.inviteid = c.inviteid
                    AND c.inviteid = a.inviteid
                    and b.AUDITFLAG = '2'
                    -- <if test=""startTime != null"">
                    --     and b.AUDITTIME &gt;= #{startTime}
                    -- </if>
                    -- <if test=""endTime != null"">
                    --     and b.AUDITTIME &lt;= #{endTime}
                    -- </if>
                union all
                SELECT
                    'zb' type,
                    c.inviteno,
                    c.INVITEDESC,
                    A.DWBM,
                    A.DWMC,
                    c.INVITECORPCODE cgdwbm,
                    c.INVITECORPDESC cgdwmc
                FROM
                    ztb_bid A,
                    ztb_integrateaudit B,
                    ztb_invite c
                WHERE
                    b.inviteid = c.inviteid
                    AND c.inviteid = a.inviteid
                    and b.AUDITFLAG = '2'
                    -- <if test=""startTime != null"">
                    --     and b.AUDITTIME &gt;= #{startTime}
                    -- </if>
                    -- <if test=""endTime != null"">
                    --     and b.AUDITTIME &lt;= #{endTime}
                    -- </if>
                union all
                SELECT
                    'ht' type,
                    a.htbm,
                    a.htmc,
                    A.DWBM,
                    A.DWMC,
                    a.xfdm,
                    a.xfmc
                FROM
                    cght a
                WHERE
                    a.swbz = '2'
                    -- <if test=""startTime != null"">
                    --     and a.sprq &gt;= #{startTime}
                    -- </if>
                    -- <if test=""endTime != null"">
                    --     and a.sprq &lt;= #{endTime}
                    -- </if>
            ) t,
            xtghdw g
        where
            g.dwbm = t.dwbm
            -- <if test=""tyshxydm!=null"">
            --     and g.yyzz=#{tyshxydm}
            -- </if>
    ) as T




-- 新 SQL
select
    count(
        distinct type,
        inviteno,
        invitedesc,
        dwbm,
        dwmc,
        cgdwbm,
        cgdwmc,
        tyshxydm,
        frsfz,
        fr
    )
from
    (
        select
            md5 (
                concat_ws ('-', type, inviteno, dwbm, cgdwbm, compare_time)
            ) as uuid,
            '0' as onuse,
            cast(null as datetime) as etl_time,
            left (dwbm, 3) as zgqybm,
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
                select
                    main.*,
                    g.yyzz as tyshxydm,
                    g.frsfz,
                    g.fr
                from
                    (
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
                            (
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
                                    ztb_bid as a
                                    inner join ztb_invite as c on a.inviteid = c.inviteid
                            ) as ac
                            inner join ztb_invitescheme as b on b.inviteschemeid = ac.inviteschemeid
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
                            (
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
                                    ztb_bid as a
                                    inner join ztb_invite as c on a.inviteid = c.inviteid
                            ) as ac
                            inner join ztb_busiaudit as b on b.inviteid = ac.inviteid
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
                            (
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
                                    ztb_bid as a
                                    inner join ztb_invite as c on a.inviteid = c.inviteid
                            ) as ac
                            inner join ztb_integrateaudit as b on b.inviteid = ac.inviteid
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
                            cght
                        where
                            swbz = '2'
                    ) as main
                    inner join xtghdw as g on g.dwbm = main.dwbm
            ) as ads
    ) as T
