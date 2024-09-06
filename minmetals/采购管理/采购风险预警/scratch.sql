select
    uid,
    id,
    yjlxid,
    zbzdrmc,
    type,
    zbzdrdwmc,
    yjfs,
    yjjb,
    zt,
    cause,
    zbbm,
    yjsj,
    yjnr,
    shrmc,
    bdbrmc,
    shrdwmc,
    yqwcsj,
    dbrq,
    zgzt,
    dbzt,
    zgdwcode,
    zbdwcode
from
    (
        with
            dws as (
                select
                    a.id,
                    a.yjlxid,
                    a.zbzdrmc,
                    a.type, -- 场景
                    a.zbzdrdwmc, -- 采购单位
                    a.yjfs, -- 预警方式
                    a.yjjb, -- 预警级别
                    a.zt, -- 处置状态
                    a.zbbm, -- 招标编码
                    a.yjsj, -- 发现时间
                    a.yjnr, -- 风险内容
                    c.shrmc, -- 督办人
                    c.bdbrmc, -- 处置人
                    c.shrdwmc, -- 督办单位
                    b.yqwcsj, -- 要求完成时间
                    b.sjjs,
                    c.dbrq, -- 督办时间
                    case b.zt
                        when 0 then '整改通知未发布'
                        when 1 then '整改报告未提交'
                        when 2 then '整改报告已提交'
                        when 3 then '整改报告不合格'
                        when 9 then '整改完成'
                    end zgzt, -- 处置状态
                    case a.dbzt
                        when 0 then '未督办'
                        when 1 then '已督办'
                        when 2 then '已反馈'
                        when 3 then '已接收'
                        else '未督办'
                    end dbzt -- 督办进度
                from
                    dw_dsep.DWD_GYL_ZTB_JK_YJXX as a
                    inner join dw_dsep.DWD_GYL_ZTB_JK_ZGTZ as b on a.id = b.yjxxid
                    left join dw_dsep.DWD_GYL_ZTB_JK_DBXX c on b.id = c.zgtzid
                where
                    a.yjfs = '0'
                    and b.zt = '1'
                    and b.yqwcsj < now ()
            ),
            main as (
                select
                    '派单超时未处理' as cause, -- 异常原因
                    *
                from
                    dws
                where
                    sjjs = '0'
                    or sjjs is null
                union all
                select
                    '已移交上级单位督办' as cause,
                    *
                from
                    dws
                where
                    sjjs = '1'
                union all
                -- 禁止操作
                select
                    '禁止操作超时未处理' as cause,
                    id,
                    yjlxid,
                    zbzdrmc,
                    type,
                    zbzdrdwmc,
                    yjfs,
                    yjjb,
                    zt,
                    zbbm,
                    yjsj,
                    yjnr,
                    '' as shrmc,
                    '' as bdbrmc,
                    '' as shrdwmc,
                    '' as yqwcsj,
                    '' as sjjs,
                    '' as dbrq,
                    '' as zgzt,
                    '' as dbzt
                from
                    dw_dsep.DWD_GYL_ZTB_JK_YJXX
                where
                    zt = '1'
                    and yjfs = '1'
            ),
            ads as (
                select
                    md5 (id) as uid,
                    strleft (b.djdwbm, 3) as zgdwcode, -- 直管单位
                    b.djdwbm as zbdwcode, -- 招标单位编码
                    id,
                    yjlxid,
                    zbzdrmc,
                    type,
                    zbzdrdwmc,
                    yjfs,
                    yjjb,
                    zt,
                    cause,
                    zbbm,
                    yjsj,
                    yjnr,
                    shrmc,
                    bdbrmc,
                    shrdwmc,
                    yqwcsj,
                    dbrq,
                    zgzt,
                    dbzt
                from
                    main
                    left join dw_dsep.DWD_GYL_ZTB_INVITESCHEME as b on main.zbbm = b.inviteno
            )
        select
            *
        from
            ads
    ) as ads