-- 派单超时
SELECT
    A.ID,
    A.YJLXID,
    A.ZBZDRMC,
    A.TYPE, -- 场景
    A.ZBZDRDWMC, -- 采购单位
    A.YJFS, -- 预警方式
    A.YJJB, -- 预警级别
    A.ZT, -- 处置状态
    '派单超时未处理' AS cause, -- 异常原因
    A.ZBBM, -- 招标编码
    A.YJSJ, -- 发现时间
    A.YJNR, -- 风险内容
    C.SHRMC, -- 督办人
    C.BDBRMC, -- 处置人
    C.SHRDWMC, -- 督办单位
    B.YQWCSJ, -- 要求完成时间
    C.DBRQ, -- 督办时间
    CASE B.ZT
        WHEN 0 THEN '整改通知未发布'
        WHEN 1 THEN '整改报告未提交'
        WHEN 2 THEN '整改报告已提交'
        WHEN 3 THEN '整改报告不合格'
        WHEN 9 THEN '整改完成'
    END ZGZT, -- 处置状态
    CASE A.DBZT
        WHEN 0 THEN '未督办'
        WHEN 1 THEN '已督办'
        WHEN 2 THEN '已反馈'
        WHEN 3 THEN '已接收'
        ELSE '未督办'
    END DBZT -- 督办进度
FROM
    ZTB_JK_YJXX A,
    ZTB_JK_ZGTZ B
    LEFT JOIN ZTB_JK_DBXX C ON B.ID = C.ZGTZID
WHERE
    A.ID = B.YJXXID
    AND A.YJFS = '0'
    AND A.YCZT = '1'