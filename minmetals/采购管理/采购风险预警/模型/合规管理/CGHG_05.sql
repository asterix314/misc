-- 合规管理：涉嫌违规操作
-- 体征：超额设置投标保证金
-- 应用名称：CGHG05
-- status: TODO



drop table if exists ods_dsep_test.ADS_CGHG_05;
create table ods_dsep_test.ADS_CGHG_05
unique key(uuid) as


with
    main as (
        select
            a.inviteno,
            a.schemedesc,
            a.invitecorpcode,
            a.invitecorpdesc,
            a.depositexes,
            a.controlpricetaxinclusive,
            a.budget,
            a.djdwbm as dwbm,
            '预算金额' as yy,
            cm.approvedate
        from
            dw_ods_dsep.ods_cg_ztb_invitescheme as a
            inner join dw_ods_dsep.ods_cg_t_audit_comment as cm on a.inviteschemeid = cm.billid
        where
            a.auditflag > '0'
            and a.controlpricetaxinclusive <> 0
            and cm.tablename = 'ZTB_INVITESCHEME'
            and cm.type = '0'
            and a.depositflag = '1'
            and (
                (
                    a.bzjlx = '0'
                    and (
                        a.depositexes > 800000
                        or a.depositexes > a.budget * 0.02
                    )
                )
                or (
                    a.bzjlx = '1'
                    and a.depositexes > 2
                )
            )
    ),
    ads as (
        select
            md5 (concat_ws ('-', inviteno, schemedesc, invitecorpcode,
            invitecorpdesc,
            depositexes,
            controlpricetaxinclusive,
            budget,
            djdwbm as dwbm,
            cm.approvedate
)) as uuid,
            '0' as onuse,
            cast(null as datetime) as etl_time,
            strleft (dwbm, 3) as zgqybm,
            main.*
        from
            main
    )
select
    *
from
    ads






                    AND CM.APPROVEDATE >= '2024-01-01' --  #{startTime}
                    AND CM.APPROVEDATE < '2024-09-01' -- #{endTime}




-- MySQL test set
SELECT
    T.INVITENO zbbm,
    T.SCHEMEDESC zbmc,
    T.INVITECORPCODE cgdwbm,
    T.INVITECORPDESC cgdwmc,
    CONCAT (
        '预算金额:',
        T.BUDGET,
        ';投标控制价:',
        T.CONTROLPRICETAXINCLUSIVE
    ) ysje,
    T.DEPOSITEXES tbbzj,
    CASE
        WHEN T.DEPOSITEXES > 800000 THEN '投标保证金>80万'
        ELSE CONCAT ('投标保证金超', GROUP_CONCAT (T.YY), '2%')
    END yy
FROM
    (
        SELECT
            A.INVITENO,
            A.SCHEMEDESC,
            A.INVITECORPCODE,
            A.INVITECORPDESC,
            A.DEPOSITEXES,
            A.CONTROLPRICETAXINCLUSIVE,
            A.BUDGET,
            '预算金额' YY
        FROM
            ZTB_INVITESCHEME A
        WHERE
            A.AUDITFLAG > '0'
            AND A.CONTROLPRICETAXINCLUSIVE <> 0
            AND A.INVITESCHEMEID IN (
                SELECT
                    CM.BILLID
                FROM
                    T_AUDIT_COMMENT CM
                WHERE
                    CM.TABLENAME = 'ZTB_INVITESCHEME'
                    AND CM.TYPE = '0'
                    AND CM.APPROVEDATE >= '2024-01-01' --  #{startTime}
                    AND CM.APPROVEDATE < '2024-09-01' -- #{endTime}
            ) 
            AND A.DEPOSITFLAG = '1'
            AND (
                (
                    A.BZJLX = '0'
                    AND (
                        A.DEPOSITEXES > 800000
                        OR A.DEPOSITEXES > A.BUDGET * 0.02
                    )
                )
                OR (
                    A.BZJLX = '1'
                    AND A.DEPOSITEXES > 2
                )
            )
    ) T
GROUP BY
    T.INVITENO,
    T.SCHEMEDESC,
    T.INVITECORPCODE,
    T.INVITECORPDESC,
    T.DEPOSITEXES,
    T.CONTROLPRICETAXINCLUSIVE,
    T.BUDGET
