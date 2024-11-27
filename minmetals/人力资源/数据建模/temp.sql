-- 1. 党组管理干部
-- insert into DWD_HR_GBDWZTQK(id,TJRQ_R,XM_L,GZDW_I,ZW_G,CSRQ_V,NL_W,XB_C,MZ_J,ZZMM_Y,XL_J,ZWLB_Y,ZZ_L)
select
    uuid () as id,
    current_date() tjrq_r,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    职务类别,
    zz_l
from
    (
        select
            uuid () as id,
            a01.a00 as a00,
            a01.a0101 as 姓名,
            ifnull (b01.zdyxb0101, b0101) as 工作单位,
            a01_function.a02_a0215_all_rmb as 职位,
            to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            a01_function.age as 年龄,
            gb22611.dmcpt as 性别,
            gb3304.dmcpt as 民族,
            gb4762.dmcpt as 政治面貌,
            a01_function.a08_a0801 as 学历,
            ifnull (hr973.dmcpt, '其他') as 职务类别,
            '党组管理干部' zz_l
        from
            ODS_HR_GBRS_A01 as a01
            left join ODS_HR_GBRS_A02 as a02 on a01.a00 = a02.a00
            and ifnull (a02.zdyxa0288, 0) = 0
            left join ODS_HR_GBRS_A02_FUNCTION as a02_function on a01.a00 = a02_function.a00
            left join ODS_HR_GBRS_A01_FUNCTION as a01_function on a01.a00 = a01_function.a00
            left join ODS_HR_GBRS_B01 as b01 on b01.b00 = a02_function.a0201b
            left join ODS_HR_GBRS_GB22611 as gb22611 on gb22611.dmcod = a01.a0104
            left join ODS_HR_GBRS_A06 as a06 on a01.a00 = a06.a00
            left join ODS_HR_GBRS_HR03 as hr03 on a01.zdyxa0110 = hr03.dmcod
            left join ODS_HR_GBRS_GB3304 as gb3304 on gb3304.dmcod = a01.a0117
            left join ODS_HR_GBRS_GB4762 as gb4762 on gb4762.dmcod = a01.a0141
            left join ODS_HR_GBRS_HR973 as hr973 on hr973.inpfrq = a01.a0219
        where
            a02_function.a02_zairenzhiwu = '1'
            and a01.zdyxa0110 = '02'
            and ifnull (a02.zdyxa0288, 0) = 0
            and a01.zdyxa0109 in ('1', '5', '6')
            and b01.b00 in (
                select
                    b00
                from
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 2. 同步rl_gbdwztqk-中国冶金科工集团有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        select
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '中冶集团' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('4030C3A1-54A6-68EE-59BF-B6F948B49304') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 3. 同步rl_gbdwztqk-五矿有色金属股份有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        select
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '五矿国际' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('E9F0796B-914A-8071-F4A3-4C83D69BBDAE') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 4. 同步rl_gbdwztqk-湖南有色金属控股集团有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        SELECT
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '湖南有色' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('90A76B77-4529-418F-654A-EB19945AE477') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 5. 同步rl_gbdwztqk-五矿发展股份有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        SELECT
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '五矿发展' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('B4B17C56-A444-D574-D37D-4ADF06551241') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 6. 同步rl_gbdwztqk-五矿发展股份有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        SELECT
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '五矿发展' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('B4B17C56-A444-D574-D37D-4ADF06551241') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 7. 同步rl_gbdwztqk-五矿资本股份有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        SELECT
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '五矿资本' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('D195367F-75F2-2516-9F3C-1E10CFDDF06E') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 8. 同步rl_gbdwztqk-五矿资本股份有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        SELECT
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '五矿资本' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('D195367F-75F2-2516-9F3C-1E10CFDDF06E') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 9. 同步rl_gbdwztqk-五矿资本股份有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        SELECT
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '五矿资本' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('D195367F-75F2-2516-9F3C-1E10CFDDF06E') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 同步rl_gbdwztqk-五矿地产有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        SELECT
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '五矿地产' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('046F54EC-5089-6936-62A6-E645BE9F6EF4') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 同步rl_gbdwztqk-五矿矿业控股有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        select
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '五矿矿业' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('26A78E64-1C08-E6AA-16B6-2252DE6D70E2') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 同步rl_gbdwztqk-中钨高新材料股份有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        select
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '中钨高新' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('1780C794-36FA-2FE1-5CFD-807E69351854') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 同步rl_gbdwztqk-长沙矿冶研究院有限责任公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        select
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy-MM-dd') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '长沙矿冶院' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('5AED37C3-AFB0-0531-7F5B-D1F44B227AB7') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 同步rl_gbdwztqk-湖南长远锂科股份有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        select
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy.MM') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '长远锂科' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('D2B6BF17-FA14-B035-1C29-A41FDEE99238') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB
    -- 同步rl_gbdwztqk-五矿勘查开发有限公司
insert into
    minmetals_monitor.rl_gbdwztqk (
        id,
        TJRQ_R,
        XM_L,
        GZDW_I,
        ZW_G,
        CSRQ_V,
        NL_W,
        XB_C,
        MZ_J,
        ZZMM_Y,
        XL_J,
        ZZ_L
    )
select
    uuid () as id,
    CURRENT_DATE() TJRQ_R,
    姓名,
    工作单位,
    职位,
    出生日期,
    年龄,
    性别,
    民族,
    政治面貌,
    学历,
    ZZ_L
FROM
    (
        select
            uuid () as id,
            A01.A00 AS A00,
            A01.A0101 AS 姓名,
            IFNULL (b01.ZDYXB0101, B0101) AS 工作单位,
            a01_function.A02_A0215_ALL_RMB AS 职位,
            ods_gbrs_minmetals.to_char (A01.A0107, 'yyyy.MM') AS 出生日期,
            A01_Function.age AS 年龄,
            GB22611.dmcpt AS 性别,
            GB3304.dmcpt AS 民族,
            GB4762.dmcpt AS 政治面貌,
            A01_FUNCTION.A08_A0801 AS 学历,
            A01_FUNCTION.A08_A0830 AS 学位,
            '勘查公司' ZZ_L
        FROM
            ods_gbrs_minmetals.A01
            LEFT JOIN ods_gbrs_minmetals.A01_Function ON A01.A00 = A01_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A02 ON A01.A00 = A02.A00
            LEFT JOIN ods_gbrs_minmetals.A02_function ON A01.A00 = A02_Function.A00
            LEFT JOIN ods_gbrs_minmetals.A06 ON A01.A00 = A06.A00
            LEFT JOIN ods_gbrs_minmetals.B01 ON B01.B00 = A02_Function.A0201B
            LEFT JOIN ods_gbrs_minmetals.ZB01 ON A01.A0111B = ZB01.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR973 ON A01.A0219 = HR973.DMCOD
            LEFT JOIN ods_gbrs_minmetals.HR03 ON A01.ZDYXA0110 = HR03.DMCOD
            LEFT JOIN ods_gbrs_minmetals.GB3304 ON GB3304.DMCOD = A01.A0117
            LEFT JOIN ods_gbrs_minmetals.GB4762 ON GB4762.DMCOD = A01.A0141
            LEFT JOIN ods_gbrs_minmetals.GB22611 ON GB22611.DMCOD = A01.A0104
        WHERE
            A02_function.A02_ZAIRENZHIWU = '1'
            AND A01.ZDYXA0109 = '1'
            AND A01.ZDYXA0110 = '03'
            AND IFNULL (A02.ZDYXA0288, 0) = 0
            AND A01.ZDYXA0109 IN ('1', '5', '6')
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
            AND B01.B00 IN (
                SELECT
                    B00
                FROM
                    ods_gbrs_minmetals.B01
                    INNER JOIN (
                        SELECT
                            ods_gbrs_minmetals.getCurAndChildB00s ('C9D4894F-AB18-36DF-F67D-2EB7EBC1A60F') B00LIST
                    ) N ON B00LIST = B00LIST
                    AND FIND_IN_SET (B00, B00LIST)
            )
        GROUP BY
            A00
    ) A00_GB