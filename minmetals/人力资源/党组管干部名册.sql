SELECT A00,
      MARKINFO,
 BPINDEX,
 APINDEX,
  姓名,
  工作单位,
  职位,
 是否为一肩挑,
 是否为专职副书记,
 出生日期,
 年龄,
 性别,
 民族,
 政治面貌,
 籍贯,
 出生地,
 职称,
 参工时间,
 入党时间,
 学历,
 学位,
 毕业院校,
 专业,
 联系方式,
 身份证号,
 备注,
 人员类别,
 单位类别,
 职务类别,
 任现职时间,
 职务级别,
 任现职务级别时间,
 干部层级,
 任现干部层级时间,
 职位序列,
 员工职级,
 任现员工职级时间,
 同企业现层级任职时间,
 现岗位按规定需交流年限,
 现层级按规定需交流年限,
 已在现岗位工作年限,
 已在同一企业现层级工作年限,
 是否需交流,
 集团总部经历,
 海外工作经历,
 京外工作经历,
 基层工作经历,
 一线企业经历,
 一线企业正职经历,
 直管企业内设机构正职经历

FROM (
SELECT A01.A00                            AS A00,
       A02_FUNCTION.MARKINFO,
 nvl(B01.PINDEX, '999-999-999-999999') AS BPINDEX,
 nvl(A02_Function.A02_Order, '999-999-999-999999') AS APINDEX,
       A01.A0101                          AS 姓名,
       IFNULL(B01.ZDYXB0101, B0101)       AS 工作单位,
       a01_function.A02_A0215_ALL_RMB             AS 职位,
       hr164a.DMCPT                       AS 是否为一肩挑,
       hr164.DMCPT                        AS 是否为专职副书记,
       to_char(A01.A0107, 'yyyy.MM')      AS 出生日期,
       A01_Function.age                   AS 年龄,
       GB22611.DMCPT                      AS 性别,
       GB3304.DMCPT                       AS 民族,
       GB4762.DMCPT                       AS 政治面貌,
       A01_FUNCTION.A01_A0111B_A0111A_RMB   AS 籍贯,
       A01_FUNCTION.A01_A0114B_A0114A_RMB AS 出生地,
          case when a01_function.A06_A0601_RMB ='无' then''   else  a01_function.A06_A0601_RMB end AS 职称,
       TO_CHAR(A01.A0134, 'yyyy.MM')      AS 参工时间,
       A01_FUNCTION.A01_A0144_RMB         AS 入党时间,
       A01_FUNCTION.A08_A0801             AS 学历,
       A01_FUNCTION.A08_A0830             AS 学位,
       A01_Function.A08_A0806_ZG          AS 毕业院校,
       A01_Function.A08_A0809_ZG          AS 专业,
       A01.ZDYXA0145                      AS 联系方式,
       A01.A0184                          AS 身份证号,
       A01.ZDYXA0199                      AS 备注,
       HR03.DMCPT                         AS 人员类别,
       HR972.DMCPT                        AS 单位类别,
       HR973.DMCPT                        AS 职务类别,
       TO_CHAR(a01.ZDYXA01S07, 'yyyy.MM') AS 任现职时间,
       HR974.DMCPT                        AS 职务级别,
       TO_CHAR(a01.ZDYXA0282, 'yyyy.MM')  AS 任现职务级别时间,
       HR975.DMCPT                        AS 干部层级,
       TO_CHAR(A01.ZDYXA0286, 'yyyy.MM')  AS 任现干部层级时间,
       HR970.DMCPT                        AS 职位序列,
       HR971.DMCPT                        AS 员工职级,
       TO_CHAR(A01.ZDYXA01S03, 'yyyy.MM') AS 任现员工职级时间,
       TO_CHAR(A49.A4940, 'yyyy.MM')      AS 同企业现层级任职时间,
       A49.A4941                          AS 现岗位按规定需交流年限,
       a49.A4942                          AS 现层级按规定需交流年限,
       a49.A4943                          AS 已在现岗位工作年限,
       a49.A4944                          AS 已在同一企业现层级工作年限,
       HR164b.DMCPT                       AS 是否需交流,
       case
           when (select count(*)
                 from a01_jlmark_r
                 where a01_jlmark_r.DMCOD = '3550660A-1408-45F3-B138-5E258370DDD9'
                   and a01_jlmark_r.A00 = a01.A00) > 0 then '有'
           else '无' end                   as 集团总部经历,
       case
           when (select count(*)
                 from a01_jlmark_r
                 where a01_jlmark_r.DMCOD = '3C30020E-20ED-454D-B06C-1C7E405F37C6'
                   and a01_jlmark_r.A00 = a01.A00) > 0 then '有'
           else '无' end                   as 海外工作经历,
       case
           when (select count(*)
                 from a01_jlmark_r
                 where a01_jlmark_r.DMCOD = '483EF7DE-1A70-442B-B247-08DE63A4238B'
                   and a01_jlmark_r.A00 = a01.A00) > 0 then '有'
           else '无' end                   as 京外工作经历,
       case
           when (select count(*)
                 from a01_jlmark_r
                 where a01_jlmark_r.DMCOD = '5E111D02-F009-44FF-9890-A595A497A4C4'
                   and a01_jlmark_r.A00 = a01.A00) > 0 then '有'
           else '无' end                   as 基层工作经历,
       case
           when (select count(*)
                 from a01_jlmark_r
                 where a01_jlmark_r.DMCOD = 'F6657E73-9782-4F75-904C-B4289E5CDC96'
                   and a01_jlmark_r.A00 = a01.A00) > 0 then '有'
           else '无' end                   as 一线企业经历,
       case
           when (select count(*)
                 from a01_jlmark_r
                 where a01_jlmark_r.DMCOD = 'CE773A9B-192B-4AEC-90DA-CBD3E28ACCAD'
                   and a01_jlmark_r.A00 = a01.A00) > 0 then '有'
           else '无' end                   as 一线企业正职经历,
       case
           when (select count(*)
                 from a01_jlmark_r
                 where a01_jlmark_r.DMCOD = 'AA6FC965-B6A0-43F7-AFE2-55A7156F0B7C'
                   and a01_jlmark_r.A00 = a01.A00) > 0 then '有'
           else '无' end                   as 直管企业内设机构正职经历
FROM A01
         LEFT JOIN A02 ON A01.A00 = A02.A00 and IFNULL(A02.ZDYXA0288,0)=0
         LEFT JOIN A02_function ON A01.A00 = A02_Function.A00 
         LEFT JOIN A01_Function ON A01.A00 = A01_Function.A00
         LEFT JOIN B01       ON b01.B00 = A02_Function.A0201B
         LEFT JOIN A06       ON A01.A00 = A06.A00
         LEFT JOIN HR03      ON a01.ZDYXA0110 = HR03.DMCOD
         LEFT JOIN GB3304    ON GB3304.dmcod  = a01.A0117
         LEFT JOIN GB22611   ON GB22611.dmcod = a01.A0104
         LEFT JOIN GB4762    ON GB4762.dmcod  = A01.A0141
         LEFT JOIN HR970     ON A01.ZDYXA01S01 = HR970.dmcod
         LEFT JOIN HR971     ON A01.ZDYXA01S02 = HR971.dmcod
         LEFT JOIN a49       ON A01.a00 = a49.a00
         LEFT JOIN HR973     ON A01.A0219   = HR973.DMCOD
         LEFT JOIN HR974     ON A01.ZDYXA0281 = HR974.DMCOD
         LEFT JOIN HR972     ON A01.ZDYXA0287 = HR972.DMCOD
         LEFT JOIN HR975     ON A01.ZDYXA0285 = HR975.DMCOD
         LEFT JOIN hr164a    ON a02.zdyxa0283 = hr164a.dmcod
         LEFT JOIN hr164     ON a02.zdyxa0284 = hr164.DMCOD
         LEFT JOIN HR164 HR164b ON a49.A4945    = HR164b.DMCOD
WHERE
  a01.ZDYXA0110 = '02' and IFNULL(A02.ZDYXA0288,0)=0
   AND A01.ZDYXA0109 IN('1','5','6')
  AND B01.B00 IN (SELECT B00
                  FROM B01
                           INNER JOIN (SELECT getCurAndChildB00s('A799F1BF-A759-AF95-C187-698530576CF9') B00LIST) N
                                      ON B00LIST = B00LIST AND FIND_IN_SET(B00, B00LIST))
  order by BPINDEX asc , APINDEX asc
) abc
GROUP BY A00
order by BPINDEX asc , APINDEX asc