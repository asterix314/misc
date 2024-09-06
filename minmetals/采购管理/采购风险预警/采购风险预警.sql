--直管单位编码和名称
create table ADS_ZGDW_BM_MC(
	zbbm varchar(255),--招标编码 加索引
	zgdwbm varchar(255),--直管单位编码
	dwmc varchar(255)--单位名称
);

--处理逻辑
SELECT
        inviteno,
        left(a.djdwbm,3) zgdwCode,
        DJDWMC
        FROM
        ZTB_INVITESCHEME A
---------------------------------------------------------------------------------------------------


--风险处理监控三级页面
create table ADS_FXYJ_THREE(
	id varchar(255),
	zgrmc varchar(255),-- 处置人名称
	yqwcsj varchar(255),-- 要求完成时间
	jssjsj varchar(255),-- 接收数据时间
	zgzt varchar(255)	--整改状态
	
);
--逻辑
SELECT
        A.ID,
        B.ZGRMC, 
        B.YQWCSJ, 
        B.JSSJSJ, 
        CASE B.ZT
        WHEN 0 THEN '整改通知未发布'
        WHEN 1 THEN '整改报告未提交'
        WHEN 2 THEN '整改报告已提交'
        WHEN 3 THEN '整改报告不合格'
        WHEN 9 THEN '整改完成' END ZGZT
        FROM
        ztb_jk_yjxx A,
        ZTB_JK_ZGTZ B LEFT JOIN
        ZTB_JK_DBXX C ON B.ID = C.ZGTZID
        WHERE
        A.ID = B.YJXXID
---------------------------------------------------------------------------------------------------


--今日风险预警
create table ADS_JRFXYJ(
	id varchar(32),--id
	yjsj datetime,--预警时间
	zt varchar(1),--状态
	yjlxid varchar(32),--预警类型id
	zbbm varchar(20),--招标编码
	type varchar(32),--类型
	yczt varchar(1),--异常状态
	ycyy varchar(128)--异常原因
);

--处理逻辑
select 
id ,
yjsj,
zt,
yjlxid,
zbbm ,
type ,
yczt ,
ycyy 
from 
ZTB_JK_YJXX 
where 
yjsj > current_date

---------------------------------------------------------------------------------------------------

-- 今日风险预警二级页面已处理
create table ADS_JRFXYJ_SECOND_YCL(
	id varchar(255)
);
	
-- 处理逻辑
SELECT id
        FROM ZTB_JK_YJXX A
        WHERE
        A.ZT = '2'
		
---------------------------------------------------------------------------------------------------
		
-- 今日风险预警二级页面异常数据
create table ADS_JRFXYJ_SECOND_YC(
	id varchar(255)
);
-- 处理逻辑
SELECT id FROM ZTB_JK_YJXX A
        WHERE A.YCZT = '1'

---------------------------------------------------------------------------------------------------

--处置异常监控
create table ADS_CZYCJK(
	id varchar(255),
	yjlxid varchar(255),
	zbzdrmc varchar(255),
	type varchar(255),
	zbzdrdwmc varchar(255),
	yjfs varchar(255),
	yjjb varchar(255),
	zt varchar(255),
	cause varchar(255),
	zbbm varchar(255),
	yjsj datetime,
	yjnr varchar(255),
	shrmc varchar(255),
	bdbrmc varchar(255),
	shrdwmc varchar(255),
	yqwcsj datetime,
	dbrq datetime,
	zgzt varchar(255),
	dbzt varchar(255),
	zgdwcode varchar(255),
	zbdwcode varchar(255)
);
--处理逻辑
SELECT A.*,
        left(b.djdwbm,3) zgdwCode, -- 直管单位
        b.djdwbm zbdwCode -- 招标单位编码
        FROM(
        -- 派单超时
        (SELECT A.ID,
        A.YJLXID,
        A.ZBZDRMC,
        A.TYPE, -- 场景
        A.ZBZDRDWMC, -- 采购单位
        A.YJFS, -- 预警方式
        A.YJJB, -- 预警级别
        A.ZT, -- 处置状态
        "派单超时未处理" AS cause, -- 异常原因
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
        WHEN 9 THEN '整改完成' END ZGZT, -- 处置状态
        CASE A.DBZT
        WHEN 0 THEN '未督办'
        WHEN 1 THEN '已督办'
        WHEN 2 THEN '已反馈'
        WHEN 3 THEN '已接收'
        ELSE '未督办' END DBZT -- 督办进度
        FROM ZTB_JK_YJXX A,
        ZTB_JK_ZGTZ B
        LEFT JOIN ZTB_JK_DBXX C ON B.ID = C.ZGTZID
        WHERE A.ID = B.YJXXID
        AND A.YJFS = '0'
        AND B.ZT IN ('1')
        AND B.YQWCSJ < NOW()
        AND (B.SJJS = '0' OR B.SJJS IS NULL)
        )
        union all
        -- 已移交上级单位督办
        (SELECT A.ID,
        A.YJLXID,
        A.ZBZDRMC,
        A.TYPE,
        A.ZBZDRDWMC,
        A.YJFS,
        A.YJJB,
        A.ZT,
        "已移交上级单位督办" AS cause,
        A.ZBBM,
        A.YJSJ,
        A.YJNR,
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
        WHEN 9 THEN '整改完成' END ZGZT, -- 处置状态
        CASE A.DBZT
        WHEN 0 THEN '未督办'
        WHEN 1 THEN '已督办'
        WHEN 2 THEN '已反馈'
        WHEN 3 THEN '已接收'
        ELSE '未督办' END DBZT -- 督办进度
        FROM ZTB_JK_YJXX A,
        ZTB_JK_ZGTZ B
        LEFT JOIN ZTB_JK_DBXX C ON B.ID = C.ZGTZID
        WHERE A.ID = B.YJXXID
        AND A.YJFS = '0'
        AND B.ZT IN ('1')
        AND B.YQWCSJ < NOW()
        AND B.SJJS = '1'

        )
        union all
        -- 禁止操作
        (SELECT A.ID,
        A.YJLXID,
        A.ZBZDRMC,
        A.TYPE,
        A.ZBZDRDWMC,
        A.YJFS,
        A.YJJB,
        A.ZT,
        "禁止操作超时未处理" AS cause,
        A.ZBBM,
        A.YJSJ,
        A.YJNR,
        "" SHRMC,
        "" BDBRMC,
        "" SHRDWMC,
        "" YQWCSJ,
        "" DBRQ,
        "" ZGZT,
        "" DBZT
        FROM ZTB_JK_YJXX A
        WHERE A.ZT = '1'
        AND A.YJFS = '1')
)A
        LEFT JOIN
        ZTB_INVITESCHEME B on A.ZBBM = B.INVITENO

---------------------------------------------------------------------------------------------------
		
-- 风险闭环处置监控
create table ADS_FXBHCZJK(
	ytsczfxx bigint,-- 已推送处置风险项
	sqyjts bigint,-- 事前预警提示
	szjzcz bigint, -- 事中禁止操作
	shpdzg bigint, -- 事后派单整改
	cswcz bigint, -- 超时未处置
	czwc bigint -- 处置完成
);
-- 处理逻辑
select 
	(select count(1) from ZTB_JK_YJXX) ytsczfxx,
	(select count(1) from ZTB_JK_YJXX where YJFS='2') sqyjts,
	(select count(1) from ZTB_JK_YJXX where YJFS='1') szjzcz,
	(select count(1) from ZTB_JK_YJXX where YJFS='0') shpdzg,
	(select count(1) from ZTB_JK_YJXX where ZT!='2' and YCZT='1') cswcz,
	(select count(1) from ZTB_JK_YJXX where ZT='2') czwc

---------------------------------------------------------------------------------------------------

-- 风险闭环处置监控二级页面
create table ADS_FXBHCZJK_SECOND(
	id varchar(255),
	type int
);
-- 处理逻辑
select 
id,type 
from 
(
(select id,'2' type
from (select id
from ztb_jk_yjxx
where YJFS = '2'
and TYPE not in ('GYS')
and zt != '2'
and yczt = '0'
group by YJLXID, ZBBM
union all
SELECT id
FROM ztb_jk_yjxx
WHERE TYPE in ('GYS')
and YJFS = '2'
and zt != '2'
and yczt = '0') b limit 500 )

union all 
(select id,'1' type
from (select id
from ztb_jk_yjxx
where YJFS = '1'
and TYPE not in ('GYS')
and zt != '2'
and yczt = '0'
group by YJLXID, ZBBM
union all
SELECT id
FROM ztb_jk_yjxx
WHERE TYPE in ('GYS')
and YJFS = '1'
and zt != '2'
and yczt = '0') b limit 500)

union all 
(select id,'0' type
from (select id
from ztb_jk_yjxx
where YJFS = '0'
and TYPE not in ('GYS')
and zt != '2'
and yczt = '0'
group by YJLXID, ZBBM
union all
SELECT id
FROM ztb_jk_yjxx
WHERE TYPE in ('GYS')
and YJFS = '0'
and zt != '2'
and yczt = '0') b limit 500)
) a

---------------------------------------------------------------------------------------------------

--风险闭环处置监控二级页面 处置完成
create table ADS_FXBHCZJK_SECOND_CZWC(
	id varchar(255)
);

--处理逻辑
select id
        from (SELECT id
        FROM ZTB_JK_YJXX A
        WHERE
        A.ZT = '2' and TYPE not in ('GYS')
        group by YJLXID, ZBBM
        union all
        SELECT id
        FROM ZTB_JK_YJXX A WHERE A.ZT = '2' and TYPE in ('GYS'))b limit 500

---------------------------------------------------------------------------------------------------
	
-- 超时未处置分析
create table ADS_CSWCZFX(
	sl bigint,-- 数量
	ycyy varchar(255) --异常原因
);
-- 处理逻辑
select
        count(1) sl,
        YCYY ycyy
        from ZTB_JK_YJXX
        where ZT!='2' and YCZT='1'
        group by YCYY	
		
---------------------------------------------------------------------------------------------------

--超时未处置分析二级页面
create table ADS_CSWCZFX_SECOND(
	id varchar(255),
	yjlxid varchar(255),
	zbzdrmc varchar(255),
	type varchar(255),
	zbzdrdwmc varchar(255),
	yjfs varchar(255),
	yjjb varchar(255),
	zt varchar(255),
	cause varchar(255),
	zbbm varchar(255),
	yjsj datetime,
	yjnr varchar(255),
	shrmc varchar(255),
	bdbrmc varchar(255),
	shrdwmc varchar(255),
	yqwcsj varchar(255),
	dbrq varchar(255),
	zgzt varchar(255),
	dbzt varchar(255),
	zgdwcode varchar(255),
	zbdwcode varchar(255)
);
--处理逻辑
SELECT A.*,
        left(b.djdwbm,3) zgdwCode, -- 直管单位
        b.djdwbm zbdwCode -- 招标单位编码
        FROM(
        -- 派单超时
        (SELECT A.ID,
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
        WHEN 9 THEN '整改完成' END ZGZT, -- 处置状态
        CASE A.DBZT
        WHEN 0 THEN '未督办'
        WHEN 1 THEN '已督办'
        WHEN 2 THEN '已反馈'
        WHEN 3 THEN '已接收'
        ELSE '未督办' END DBZT -- 督办进度
        FROM ZTB_JK_YJXX A,
        ZTB_JK_ZGTZ B
        LEFT JOIN ZTB_JK_DBXX C ON B.ID = C.ZGTZID
        WHERE A.ID = B.YJXXID
        AND A.YJFS = '0'
        AND A.YCZT = '1'
        )
        union all
        -- 已移交上级单位督办
        (SELECT A.ID,
        A.YJLXID,
        A.ZBZDRMC,
        A.TYPE,
        A.ZBZDRDWMC,
        A.YJFS,
        A.YJJB,
        A.ZT,
        '已移交上级单位督办' AS cause,
        A.ZBBM,
        A.YJSJ,
        A.YJNR,
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
        WHEN 9 THEN '整改完成' END ZGZT, -- 处置状态
        CASE A.DBZT
        WHEN 0 THEN '未督办'
        WHEN 1 THEN '已督办'
        WHEN 2 THEN '已反馈'
        WHEN 3 THEN '已接收'
        ELSE '未督办' END DBZT -- 督办进度
        FROM ZTB_JK_YJXX A,
        ZTB_JK_ZGTZ B
        LEFT JOIN ZTB_JK_DBXX C ON B.ID = C.ZGTZID
        WHERE A.ID = B.YJXXID
        AND A.YJFS = '0'
        AND A.YCZT='1')
        union all
        -- 禁止操作
        (SELECT A.ID,
        A.YJLXID,
        A.ZBZDRMC,
        A.TYPE,
        A.ZBZDRDWMC,
        A.YJFS,
        A.YJJB,
        A.ZT,
        '禁止操作超时未处理' AS cause,
        A.ZBBM,
        A.YJSJ,
        A.YJNR,
        '' SHRMC,
        '' BDBRMC,
        '' SHRDWMC,
        '' YQWCSJ,
        '' DBRQ,
        '' ZGZT,
        '' DBZT
        FROM ZTB_JK_YJXX A
        WHERE A.ZT = '1'
        AND A.YJFS = '1'
        AND A.YCZT = '1')
        )A
        LEFT JOIN
        ZTB_INVITESCHEME B on A.ZBBM = B.INVITENO

---------------------------------------------------------------------------------------------------

--超时未处置分析二级页面id列表
create table ADS_CSWCZFX_SECOND_IDS(
	id varchar(255),-- id
	ycyy varchar(255)-- 异常原因
);
--处理逻辑

SELECT
        id,YCYY 
        FROM
        ZTB_JK_YJXX A
        WHERE
        A.YCZT='1' and TYPE not in ('GYS') 
        group by A.YJLXID, A.ZBBM,A.YCYY
        union all
        SELECT id,YCYY 
        FROM ZTB_JK_YJXX A WHERE A.YCZT='1' and TYPE in ('GYS') 

---------------------------------------------------------------------------------------------------




		



		
