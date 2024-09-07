select
    uid,
    id,
    etl_time
from
    (
        with
            main as (
                select
                    any_value (id) as id
                from
                    dw_dsep.DWD_GYL_ZTB_JK_YJXX
                where
                    ZT = '2'
                    and `TYPE` != 'GYS'
                group by
                    yjlxid,
                    zbbm
                union all
                select
                    id
                from
                    dw_dsep.DWD_GYL_ZTB_JK_YJXX
                where
                    ZT = '2'
                    and `type` = 'GYS'
            ),
            ads as (
                select
                    md5 (id) as uid,
                    null as etl_time,
                    id
                from
                    main
            )
        select
            *
        from
            ads
    ) as ads