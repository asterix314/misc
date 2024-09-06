-- 合规管理：竞争性谈判采购违规
-- 体征：评审委员会组建违规
-- 应用名称：CGHG36



drop table if exists ods_dsep_test.ADS_CGHG_29;
create table ods_dsep_test.ADS_CGHG_29
unique key(uuid) as









-- MySQL test set
SELECT
    TT.XJBM zbbm,
    TT.XJMC zbmc,
    TT.DJDWBM cgdwbm,
    TT.DJDWMC_U cgdwmc,
    '评审委员会采购人代表超过规定人数' AS yy
FROM
    (
        SELECT
            X.XJBM,
            X.XJMC,
            X.DJDWBM,
            X.DJDWMC_U,
            G.PWRS,
            (
                SELECT
                    COUNT(1)
                FROM
                    CGXJ_ZJCQ_QR_PW PW,
                    ZTB_EXPERT E
                WHERE
                    PW.ZJCQBM = G.ID
                    AND PW.EXPERTID = E.EXPERTID
                    AND E.DWBM = X.DJDWBM
            ) CQPWCNT,
            (
                SELECT
                    COUNT(1)
                FROM
                    CGXJ_ZJCQ_QR_ZJ Z,
                    ZTB_EXPERT E
                WHERE
                    Z.ZJCQBM = G.ID
                    AND Z.EXPERTID = E.EXPERTID
                    AND E.DWBM = X.DJDWBM
            ) CQZJCNT
        FROM
            CGXJ X,
            CGXJS S,
            CGXJ_ZJCQ_QR G
        WHERE
            X.XJBM = S.XJBM
            AND S.XJBM = G.XJBM
            AND S.PUBLISH = '1'
            AND S.ZDSJ >= '2024-01-01' -- #{startTime}
            AND S.ZDSJ < '2024-09-01' -- #{endTime}
    ) TT
WHERE
    (TT.CQPWCNT + TT.CQZJCNT) / TT.PWRS > 0.33



