select
    uuid,
    onuse,
    etl_time,
    zgqybm,
    zbbm,
    zbmc,
    cgdwbm,
    cgdwmc,
    zgyssj,
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
                    ysbg.shsj as zgyssj,
                    '资格预审评审结束后未及时发布资格预审结果' as yy,
                    date_add (ysbg.shsj, interval 3 day) as compare_time
                from
                    dw_ods_dsep.ods_cg_ztb_invitescheme as c
                    inner join dw_ods_dsep.ods_cg_ztb_zgyswj as wj on c.inviteno = wj.zbbm
                    inner join dw_ods_dsep.ods_cg_ztb_zgysbg_sc as ysbg on ysbg.zgyswjbm = wj.zgyswjbm
                where
                    wj.shbz = '2'
                    and ysbg.shbz = '2'
                    and wj.zbbm not in (
                        select
                            zbbm
                        from
                            dw_ods_dsep.ods_cg_ztb_zgyswj_tzs
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
                            zgyssj,
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
                    zgyssj,
                    yy
                from
                    ads
                where
                    compare_time >= '2023-01-01' -- #{startTime}
                    and compare_time < '2024-09-01' --  #{endTime}
            )
        select
            *
        from
            ads
    ) as ads