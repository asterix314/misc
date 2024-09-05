select
    uuid,
    onuse,
    etl_time,
    zgqybm, -- 直管企业编码
    zbbm,
    zbmc,
    cgdwbm,
    cgdwmc,
    zbjggsfbsj,
    yy,
    compare_time
from
    (
        with
            main as (
                select
                    c.inviteno as zbbm,
                    c.schemedesc as zbmc,
                    c.invitecorpcode as cgdwbm,
                    c.invitecorpdesc as cgdwmc,
                    p.audittime as zbjggsfbsj,
                    '中标结果公示后，未及时发布中标通知书' as yy,
                    date_add (p.audittime, interval 10 day) as compare_time
                from
                    dw_ods_dsep.ods_cg_ztb_invitescheme as c
                    inner join dw_ods_dsep.ods_cg_ztb_invite as i on c.inviteschemeid = i.inviteschemeid
                    inner join dw_ods_dsep.ods_cg_ztb_integrateaudit as a on i.inviteid = a.inviteid
                    inner join dw_ods_dsep.ods_cg_ztb_result_publicity as p on p.auditno = a.auditno
                where
                    p.auditflag = '2'
                    and c.zbxmlx = '1'
                    and c.inviteno not in (
                        select
                            lxbm
                        from
                            dw_ods_dsep.ods_cg_zbtzs
                        where
                            workflowstatus = '2'
                    )
            ),
            ads as (
                select
                    md5 (
                        concat_ws (
                            '-',
                            zbbm,
                            zbmc,
                            cgdwbm,
                            cgdwmc,
                            zbjggsfbsj,
                            yy,
                            compare_time
                        )
                    ) as uuid,
                    '0' as onuse,
                    cast(null as datetime) as etl_time,
                    strleft (cgdwbm, 3) as zgqybm, -- 直管企业编码
                    main.*
                from
                    main
            ),
            test as (
                select
                    zbbm,
                    zbmc,
                    cgdwbm,
                    cgdwmc,
                    zbjggsfbsj,
                    yy
                from
                    ads
                where
                    true
                    and compare_time >= '2024-01-01' --  #{startTime}
                    and compare_time < '2024-09-01' -- #{endTime}
            )
        select
            *
        from
            ads
    ) as ads