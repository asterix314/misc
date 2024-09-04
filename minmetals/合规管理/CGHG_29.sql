-- 合规管理：操作时间不合规（依法必招）
-- 体征：中标通知书延时
-- 应用名称：CGHG29



drop table if exists ods_dsep_test.ADS_CGHG_29;
create table ods_dsep_test.ADS_CGHG_29
unique key(uuid) as









-- MySQL test set
SELECT
    C.INVITENO zbbm,
    C.SCHEMEDESC zbmc,
    C.INVITECORPCODE cgdwbm,
    C.INVITECORPDESC cgdwmc,
    P.AUDITTIME zbjggsfbsj,
    '中标结果公示后，未及时发布中标通知书' AS yy
FROM
    ZTB_INVITESCHEME C,
    ZTB_INVITE I,
    ZTB_INTEGRATEAUDIT A,
    ZTB_RESULT_PUBLICITY P
WHERE
    C.INVITESCHEMEID = I.INVITESCHEMEID
    AND I.INVITEID = A.INVITEID
    AND P.AUDITNO = A.AUDITNO
    AND P.AUDITFLAG = '2'
    AND C.zbxmlx = '1'
    AND DATE_ADD (P.AUDITTIME, INTERVAL 10 DAY) >= '2024-01-01' -- #{startTime}
    AND DATE_ADD (P.AUDITTIME, INTERVAL 10 DAY) < '2024-09-01' -- #{endTime}
    AND NOT EXISTS (
        SELECT
            1
        FROM
            ZBTZS Z
        WHERE
            Z.LXBM = C.INVITENO
            AND Z.WORKFLOWSTATUS = '2'
    )