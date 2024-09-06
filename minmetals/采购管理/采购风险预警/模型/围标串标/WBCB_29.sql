-- 围标串标：中标率畸高、畸低
-- 体征：低中标率异常
-- 应用名称：WBCB29
-- 测试：通过
-- 使用：DWD


-- drop table if exists ods_dsep_test.ADS_WBCB_29;
-- create table ods_dsep_test.ADS_WBCB_29
-- unique key(uuid) as
select
    uuid,
    onuse,
    etl_time,
    zgqybm,
    dwmc,
    dwbm,
    win,
    uname,
    umemo,
    zbzdrdwbm,
    zbzdrdwmc,
    audittime
from
    (
        with
            z as (
                select
                    p.uname,
                    p.umemo,
                    d.dwbm as zbzdrdwbm,
                    d.dwmc as zbzdrdwmc
                from
                    dw_dsep.DWD_GYL_PURCHASE_LIBRARIANS as p
                    left join dw_dsep.DWD_GYL_T_WH_USERINFO as u on u.uname = p.uname
                    left join dw_dsep.DWD_GYL_XTLLDW as d on d.dwbm = u.dwdm
                where
                    p.orgid = '2'
            ),
            main as (
                select
                    c.dwmc,
                    c.dwbm,
                    case
                        when b.awardflag = '1'
                        and d.abortinvite = '0' then 1
                        else 0
                    end as win,
                    z.uname,
                    z.umemo,
                    z.zbzdrdwbm,
                    z.zbzdrdwmc,
                    a.audittime
                from
                    dw_dsep.DWD_GYL_ZTB_INTEGRATEAUDIT as a
                    inner join dw_dsep.DWD_GYL_ZTB_INTEGRATEAUDITSUPP as b on a.integrateauditid = b.integrateauditid
                    inner join dw_dsep.DWD_GYL_ZTB_BID as c on b.bidid = c.bidid
                    inner join dw_dsep.DWD_GYL_ZTB_INVITE as d on a.inviteid = d.inviteid
                    inner join dw_dsep.DWD_GYL_ZTB_INVITESCHEME as e on e.inviteschemeid = d.inviteschemeid
                    cross join z
                where
                    a.auditflag = '2'
                    and c.busi_releaseflag = '1'
            ),
            ads as (
                select
                    md5 (concat_ws ('-', dwbm, win, audittime)) as uuid,
                    '0' as onuse,
                    cast(null as datetime) as etl_time,
                    strleft (dwbm, 3) as zgqybm,
                    main.*
                from
                    main
            ),
            test as (
                select
                    dwbm,
                    dwmc,
                    sum(win) as optcount,
                    count(1) as bidcount,
                    cast(round(sum(win) * 100 / count(1)) as varchar) as data,
                    uname,
                    umemo,
                    zbzdrdwbm,
                    zbzdrdwmc
                from
                    ads
                where
                    audittime >= '2024-01-01'
                    and audittime < '2024-09-01'
                group by
                    dwbm,
                    dwmc,
                    uname,
                    umemo,
                    zbzdrdwbm,
                    zbzdrdwmc
                having
                    sum(win) >= 15
            )
        select
            *
        from
            ads
    ) as ads


-- Doris test set
drop table if exists ods_dsep_test.TEST_WBCB_29;
create table ods_dsep_test.TEST_WBCB_29
duplicate key(dwbm) 
as
select * from test



-- MySQL test set
SELECT
    T.DWMC DWMC,
    T.DWBM DWBM,
    t.data optCount,
    k.data bidCount,
    P.UNAME,
    P.UMEMO,
    D.DWBM zbzdrdwbm,
    D.DWMC zbzdrdwmc,
    FORMAT (t.data / k.data * 100, 0) data
FROM
    (
        SELECT
            C.DWMC,
            C.DWBM,
            COUNT(1) data
        FROM
            ZTB_INTEGRATEAUDIT A,
            ZTB_INTEGRATEAUDITSUPP B,
            ZTB_BID C,
            ZTB_INVITE D,
            ZTB_INVITESCHEME E
        WHERE
            A.AUDITFLAG = '2'
            AND A.INTEGRATEAUDITID = B.INTEGRATEAUDITID
            AND B.BIDID = C.BIDID
            AND B.AWARDFLAG = '1'
            AND D.ABORTINVITE = '0'
            AND C.BUSI_RELEASEFLAG = '1'
            AND E.INVITESCHEMEID = D.INVITESCHEMEID
            AND A.INVITEID = D.INVITEID
            AND A.AUDITTIME >= '2024-01-01'
            and A.AUDITTIME < '2024-09-01'
        GROUP BY
            C.DWMC
        having
            data >= 15
    ) T
    inner JOIN (
        SELECT
            C.DWMC,
            C.DWBM,
            COUNT(1) data
        FROM
            ZTB_INTEGRATEAUDIT A,
            ZTB_INTEGRATEAUDITSUPP B,
            ZTB_BID C,
            ZTB_INVITE D,
            ZTB_INVITESCHEME E
        WHERE
            A.AUDITFLAG = '2'
            AND A.INTEGRATEAUDITID = B.INTEGRATEAUDITID
            AND B.BIDID = C.BIDID
            AND C.BUSI_RELEASEFLAG = '1'
            AND E.INVITESCHEMEID = D.INVITESCHEMEID
            AND A.INVITEID = D.INVITEID
            AND A.AUDITTIME >= '2024-01-01'
            and A.AUDITTIME < '2024-09-01'
        GROUP BY
            C.DWMC
    ) K ON T.DWMC = K.DWMC
    inner JOIN PURCHASE_LIBRARIANS P ON P.ORGID = '2'
    LEFT join t_wh_userinfo u on u.uname = p.uname
    LEFT join xtlldw d on d.dwbm = u.dwdm


-- test
with
    test as (
        select
            md5 (
                concat_ws (
                    '-',
                    dwbm,
                    dwmc,
                    optcount,
                    bidcount,
                    data,
                    uname,
                    umemo,
                    zbzdrdwbm,
                    zbzdrdwmc
                )
            ) as rh
        from
            TEST_WBCB_29
    ),
    mcc as (
        select
            md5 (
                concat_ws (
                    '-',
                    dwbm,
                    dwmc,
                    optcount,
                    bidcount,
                    data,
                    uname,
                    umemo,
                    zbzdrdwbm,
                    zbzdrdwmc
                )
            ) as rh
        from
            TEST_WBCB_29
    )
select
    test.rh as test, mcc.rh as mcc
from
    test
    full join mcc using (rh)
where test.rh is null or mcc.rh is null