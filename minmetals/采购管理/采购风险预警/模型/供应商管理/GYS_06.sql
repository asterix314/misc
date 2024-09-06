-- 供应商管理
-- 要素：违规评审
-- 体征：供应商入库评审不符合制度及相关要求
-- 应用名称：GYS06
-- TODO

drop table if exists ods_dsep_test.ADS_GYS_06;
create table ods_dsep_test.ADS_GYS_06
unique key(uuid) as 
with a as ( -- 评审专家数目不合规
    select
        xtghdw_yw_zr_zrpsfa_gys_id as id,
        case
            when count(1) < 3 then '评审专家不满3个'
            else '评审专家不为单数'
        end as yjyy
    from
        ods_cg_xtghdw_yw_zr_zj_zxdf
    group by
        xtghdw_yw_zr_zrpsfa_gys_id
    having
        count(1) % 2 = 0
        or count(1) > 3),
exclude_gysbm as (  -- ?
    select distinct g.gysbm
    from
        ods_cg_xtghdw_yw_zr_zrpsfa_gys as g
        inner join ods_cg_xtghdw_yw_zr_zj_zxdf as z on
            g.id = z.xtghdw_yw_zr_zrpsfa_gys_id
        inner join ods_cg_xtghdw_yw_zr_zj_zxdfmx as mx on
            z.id = mx.xtghdw_yw_zr_zj_zxdf_id
        inner join ods_cg_xtghdw_xt_jcsj_dfmbmx as mb on
            mx.dfbmmxid = mb.id
    where
        g.gysbm is not null
        and mb.veto = 1
        and mx.qt = 'no'),
grades as ( -- 评分
    select 
        a.id, 
        a.xtghdw_yw_zr_zrpsfa_gys_id,
        coalesce(
            case when a.zrpsfabm is not null and a.sfzxps='1' 
                then gys.zf else id.zf end, 
            0) as zf
    from 
        ods_cg_xtghdw_yw_zr_zrpsjg_bg as a
        left join (
            select xtghdw_yw_zr_zrpsfa_gys_id as gys_id, avg(zf) as zf
            from ods_cg_xtghdw_yw_zr_zj_zxdf
            where tjbz = '1'
            group by xtghdw_yw_zr_zrpsfa_gys_id) as gys
        on a.xtghdw_yw_zr_zrpsfa_gys_id = gys.gys_id
        left join (
            select 
                bgdf.xtghdw_yw_zr_zrpsjg_zrpsbg_id as id,
                sum(bgdf.df * dfx.zbxqz / 100) as zf 
            from
                ods_cg_xtghdw_yw_zr_zrpsjg_bg_xx_df as bgdf
                inner join ods_cg_xtghdw_yw_zr_zrpsfa_df as dfx 
                on bgdf.xtghdw_yw_zr_zrpsfa_df_id = dfx.id
           group by bgdf.xtghdw_yw_zr_zrpsjg_zrpsbg_id) as id 
        on a.id = id.id),
y1 as (  -- 原因1：评审专家数目不合规
    select
        f.zrpsjgbm as inviteno,
        d.dwbm,
        d.dwmc,
        d.yyzz,
        d.tjdwmc,
        d.tjdwbm,
        f.sfzxps as psfs,
        f.sfzr,
        a.yjyy,
        f.shsj as compare_time
    from 
        a
        inner join ods_cg_xtghdw_yw_zr_zrpsfa_gys as g on 
            a.id = g.id
        inner join ods_cg_xtghdw_yw_zr_zrpsjg_bg as f on
            g.zrpsfabm = f.zrpsfabm  
            and g.gysbm = f.gysbm
        inner join ods_cg_xtghdw as d on 
            g.gysbm = d.dwbm
    where
        f.shbz = '2'
        and f.zbshbz = '0'
        and d.shef = 'CN'
        and f.sfzxps = '1'
        and d.sfzr = '0'),
y2 as (  -- 原因2：供应商业务分类与准入业务分类不一致
    select
        bg.zrpsjgbm as inviteno,
        d.dwbm,
        d.dwmc,
        d.yyzz ,
        d.tjdwmc ,
        d.tjdwbm,
        bg.sfzxps as psfs,
        d.sfzr,
        '供应商业务分类与准入业务分类不一致' as yjyy,
        bg.shsj as compare_time
    from 
        ods_cg_xtghdw_yw_zr_zrpsfa as f
        inner join ods_cg_xtghdw_yw_zr_zrpsfa_gys as g on
            f.zrpsfabm = g.zrpsfabm
        inner join ods_cg_xtghdw as d on
            g.gysbm = d.dwbm
        inner join ods_cg_xtghdw_yw_zr_zrpsjg_bg as bg on
            f.zrpsfabm = bg.zrpsjgbm
            and g.gysbm = bg.gysbm
    where 
        bg.shbz = '2'
        and bg.zbshbz = '0'
        and bg.shbz > '0'
        and d.shef = 'CN'
        and d.sfzr = '0'
        and bg.sfzxps = '1'
        and d.sfzr = '0'
        and f.businessclassification != d.businessclassification),
y3 as (  -- 原因3：总分小于60
    select 
        a.zrpsjgbm as inviteno,
        d.dwbm,
        d.dwmc,
        d.yyzz,
        d.tjdwmc,
        d.tjdwbm,
        a.sfzxps as psfs,
        d.sfzr,
        '总分小于60' yjyy,
        a.shsj as compare_time
    from 
        ods_cg_xtghdw_yw_zr_zrpsjg_bg as a
        inner join ods_cg_xtghdw_yw_zr_zrpsfa_gys as g on
            a.xtghdw_yw_zr_zrpsfa_gys_id = g.id
        inner join ods_cg_xtghdw_yw_zr_zrpsfa as f on
            f.zrpsfabm = g.zrpsfabm
        inner join ods_cg_xtghdw as d on
            g.gysbm = d.dwbm
        left join grades on
            a.id = grades.id 
            and a.xtghdw_yw_zr_zrpsfa_gys_id = grades.xtghdw_yw_zr_zrpsfa_gys_id
    where 
        a.shbz = '2'
        and a.zbshbz = '0'
        and d.shef = 'CN'
        and a.sfzxps = '1'
        and grades.zf < 60
        and d.sfzr = '0'),
y4 as (  -- unfinished.
    select 
        f.zrpsjgbm as inviteno,
        d.dwbm,
        d.dwmc ,
        max(d.yyzz) as yyzz ,
        max(d.tjdwmc) as tjdwmc ,
        max(d.tjdwbm) as tjdwbm ,
        f.sfzxps as psfs,
        d.sfzr,
        case 
            when d.dwmc is not null then '无重大不良信用记录或近三月银行资信证明或三年经营业绩栏响应附件缺失' 
            else '' 
        end as yjyy,
        f.shsj as compare_time
    from
        ods_cg_xtghdw as d
        inner join ods_cg_xtghdw_yw_zr_zrpsfa_gys as g on
            g.gysbm = d.dwbm
        ods_cg_xtghdw_yw_zr_zrpsjg_bg as f on 
            g.gysbm = f.gysbm
            and f.zrpsfabm = g.zrpsfabm
    where
        f.shbz = '2'
        and f.zbshbz = '0'
        and d.shef = 'CN'
        and f.sfzxps = '1'
        and d.sfzr = '0'
        and not exists(
            select 1
            from exclude_gysbm
                ods_cg_xtghdw_yw_zr_zrpsfa_gys g,
        xtghdw_yw_zr_zj_zxdf z,
        xtghdw_yw_zr_zj_zxdfmx mx,
        xtghdw_xt_jcsj_dfmbmx mb
        where
        g.gysbm = d.dwbm
        and g.id = z.xtghdw_yw_zr_zrpsfa_gys_id
        and z.id = mx.xtghdw_yw_zr_zj_zxdf_id
        and mx.dfbmmxid = mb.id
        and mb.veto = 1
        and mx.qt = 'no'
        )

        
        
        
        and (
        
        select
    count(1)
from
    b2b_ghdw_pfbz b,
    xtxxfj fj
where
    b.ghdwid = d.DWBM
    and fj.ywpk01 = cast(b.id as char)
    and fj.ywbm = 'B2B_GHDW_PFBZ'
    and b.ZBFXMC in(
        '无重大不良信用记录', '近三月银行资信证明', '申请准入产品近三年经营业绩', '申请准入业务近三年经营业绩', '服务商对本申请业务的近三年业绩'
    )) & lt; 3
        
        
                group by d.DWMC
      

select TT.INVITENO inviteno,tt.dwbm gysbm,tt.dwmc gysmc,max(tt.YYZZ) tyshxydm,max(tt.TJDWMC) zrdwmc,max(tt.TJDWBM) zrdwbm,tt.psfs,TT.SFZR sfzr,GROUP_CONCAT(tt.yjyy Separator ';') yyjj from (
y1
union all
y2
union all
y3
union all
y4
        union all
        SELECT BG.ZRPSJGBM INVITENO,d.dwbm,d.DWMC ,
        max(d.YYZZ) YYZZ ,
        max(d.TJDWMC) TJDWMC ,
        max(d.TJDWBM) TJDWBM ,
        bg.SFZXPS psfs,
        D.SFZR,
        case when D.DWMC is not null  then '打分栏＞0分，但响应附件缺失' else '' end yjyy
        from
        xtghdw_yw_zr_zj_zxdfmx t
        inner join xtghdw_yw_zr_zrpsfa_df df on df.id = t.XTGHDW_YW_ZR_ZRPSFA_DF_ID
        inner join xtghdw_yw_zr_zrpsfa f on DF.ZRPSFABM = F.ZRPSFABM
        inner join xtghdw_yw_zr_zj_zxdf zj on zj.ID  = t.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        inner join xtghdw_yw_zr_zrpsfa_gys gys on gys.ID  = zj.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        inner join xtghdw d on d.DWBM  = gys.GYSBM
        inner join b2b_ghdw_pfbz p on p.ghdwid = d.DWBM  and t.dfbmmxid  = p.dfmbmxid
        inner join XTGHDW_YW_ZR_ZRPSJG_BG BG on BG.ZRPSFABM  = F.ZRPSFABM and BG.GYSBM = gys.GYSBM
        where
        <if test=startTime != null>
            BG.SHSJ &gt;= #{startTime}
        </if>
        <if test=endTime != null>
            AND BG.SHSJ &lt;= #{endTime}
        </if>
        <if test=tyshxydm!=null>
            AND d.YYZZ = #{tyshxydm}
        </if>
        AND BG.SHBZ = '2'
        AND BG.ZBSHBZ = '0'
        and not EXISTS(select 1 from xtxxfj fj where fj.ywpk01 = cast(p.id as CHAR))
        and bg.SFZXPS = '1'
        and d.sfzr = '0'
        and NOT EXISTS(
        SELECT
        1
        FROM
        XTGHDW_YW_ZR_ZRPSFA_GYS G,
        XTGHDW_YW_ZR_ZJ_ZXDF Z,
        XTGHDW_YW_ZR_ZJ_ZXDFMX MX,
        XTGHDW_XT_JCSJ_DFMBMX MB
        WHERE
        G.GYSBM = D.DWBM
        AND G.ID = Z.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        AND Z.ID = MX.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        AND MX.DFBMMXID = MB.ID
        AND MB.VETO = 1
        AND MX.QT = 'no'
        )
        group by d.DWMC
        union all
        SELECT BG.ZRPSJGBM INVITENO,d.dwbm,d.DWMC ,
        max(d.YYZZ) YYZZ ,
        max(d.TJDWMC) TJDWMC ,
        max(d.TJDWBM) TJDWBM ,
        bg.SFZXPS psfs,
        D.SFZR,
        '纳税人类别栏得分应为（1、2、3、5）中的一种情形' yjyy
        FROM
        xtghdw_yw_zr_zj_zxdfmx t
        inner join xtghdw_yw_zr_zrpsfa_df df on df.id = t.XTGHDW_YW_ZR_ZRPSFA_DF_ID
        inner join xtghdw_yw_zr_zrpsfa f on DF.ZRPSFABM = F.ZRPSFABM
        inner join xtghdw_yw_zr_zj_zxdf zj on zj.ID  = t.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        inner join xtghdw_yw_zr_zrpsfa_gys gys on gys.ID  = zj.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        inner join xtghdw d on d.DWBM  = gys.GYSBM
        inner join b2b_ghdw_pfbz p on p.ghdwid = d.DWBM  and t.dfbmmxid  = p.dfmbmxid
        inner join XTGHDW_YW_ZR_ZRPSJG_BG BG on BG.ZRPSFABM  = F.ZRPSFABM and BG.GYSBM = gys.GYSBM
        where
        <if test=startTime != null>
            BG.SHSJ &gt;= #{startTime}
        </if>
        <if test=endTime != null>
            AND BG.SHSJ &lt;= #{endTime}
        </if>
        <if test=tyshxydm!=null>
            AND d.YYZZ = #{tyshxydm}
        </if>
        AND BG.SHBZ = '2'
        AND BG.ZBSHBZ = '0' AND D.SHEF = 'CN'
        and D.DWMC is not null
        and  P.ZBFXMC = '纳税人类别'
        and zj.TJBZ  = '1'
        and bg.SFZXPS = '1'
        and d.sfzr = '0'
        and NOT EXISTS(
        SELECT
        1
        FROM
        XTGHDW_YW_ZR_ZRPSFA_GYS G,
        XTGHDW_YW_ZR_ZJ_ZXDF Z,
        XTGHDW_YW_ZR_ZJ_ZXDFMX MX,
        XTGHDW_XT_JCSJ_DFMBMX MB
        WHERE
        G.GYSBM = D.DWBM
        AND G.ID = Z.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        AND Z.ID = MX.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        AND MX.DFBMMXID = MB.ID
        AND MB.VETO = 1
        AND MX.QT = 'no'
        )
        group by d.DWMC
        having avg(t.df) not in
        <foreach collection=nsrlbldfList item=item open=( separator=, close=)>
            #{item}
        </foreach>
        union all
        SELECT BG.ZRPSJGBM INVITENO,d.dwbm,d.DWMC ,
        max(d.YYZZ) YYZZ ,
        max(d.TJDWMC) TJDWMC ,
        max(d.TJDWBM) TJDWBM ,
        bg.SFZXPS psfs,
        D.SFZR,
        '近三月银行资信证明栏得分应为（0、2、5）中的一种情形' yjyy
        FROM
        xtghdw_yw_zr_zj_zxdfmx t
        inner join xtghdw_yw_zr_zrpsfa_df df on df.id = t.XTGHDW_YW_ZR_ZRPSFA_DF_ID
        inner join xtghdw_yw_zr_zrpsfa f on DF.ZRPSFABM = F.ZRPSFABM
        inner join xtghdw_yw_zr_zj_zxdf zj on zj.ID  = t.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        inner join xtghdw_yw_zr_zrpsfa_gys gys on gys.ID  = zj.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        inner join xtghdw d on d.DWBM  = gys.GYSBM
        inner join b2b_ghdw_pfbz p on p.ghdwid = d.DWBM  and t.dfbmmxid  = p.dfmbmxid
        inner join XTGHDW_YW_ZR_ZRPSJG_BG BG on BG.ZRPSFABM  = F.ZRPSFABM and BG.GYSBM = gys.GYSBM
        where
        <if test=startTime != null>
            BG.SHSJ &gt;= #{startTime}
        </if>
        <if test=endTime != null>
            AND BG.SHSJ &lt;= #{endTime}
        </if>
        <if test=tyshxydm!=null>
            AND d.YYZZ = #{tyshxydm}
        </if>
        AND BG.SHBZ = '2'
        AND BG.ZBSHBZ = '0' AND D.SHEF = 'CN'
        and D.DWMC is not null
        and P.ZBFXMC = '近三月银行资信证明'
        and zj.TJBZ  = '1'
        and bg.SFZXPS = '1'
        and d.sfzr = '0'
        and NOT EXISTS(
        SELECT
        1
        FROM
        XTGHDW_YW_ZR_ZRPSFA_GYS G,
        XTGHDW_YW_ZR_ZJ_ZXDF Z,
        XTGHDW_YW_ZR_ZJ_ZXDFMX MX,
        XTGHDW_XT_JCSJ_DFMBMX MB
        WHERE
        G.GYSBM = D.DWBM
        AND G.ID = Z.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        AND Z.ID = MX.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        AND MX.DFBMMXID = MB.ID
        AND MB.VETO = 1
        AND MX.QT = 'no'
        )
        group by d.DWMC
        having avg(t.df) not in
        <foreach collection=jsyyhzxzmldfList item=item open=( separator=, close=)>
            #{item}
        </foreach>
        union all
        SELECT BG.ZRPSJGBM INVITENO,d.dwbm,d.DWMC ,
        max(d.YYZZ) YYZZ ,
        max(d.TJDWMC) TJDWMC ,
        max(d.TJDWBM) TJDWBM ,
        bg.SFZXPS psfs,
        D.SFZR,
        '资产负债率栏得分应为（0、1、3、5）中的一种情形' yjyy
        FROM
        xtghdw_yw_zr_zj_zxdfmx t
        inner join xtghdw_yw_zr_zrpsfa_df df on df.id = t.XTGHDW_YW_ZR_ZRPSFA_DF_ID
        inner join xtghdw_yw_zr_zrpsfa f on DF.ZRPSFABM = F.ZRPSFABM
        inner join xtghdw_yw_zr_zj_zxdf zj on zj.ID  = t.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        inner join xtghdw_yw_zr_zrpsfa_gys gys on gys.ID  = zj.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        inner join xtghdw d on d.DWBM  = gys.GYSBM
        inner join b2b_ghdw_pfbz p on p.ghdwid = d.DWBM  and t.dfbmmxid  = p.dfmbmxid
        inner join XTGHDW_YW_ZR_ZRPSJG_BG BG on BG.ZRPSFABM  = F.ZRPSFABM and BG.GYSBM = gys.GYSBM
        where
        <if test=startTime != null>
            BG.SHSJ &gt;= #{startTime}
        </if>
        <if test=endTime != null>
            AND BG.SHSJ &lt;= #{endTime}
        </if>
        <if test=tyshxydm!=null>
            AND d.YYZZ = #{tyshxydm}
        </if>
        AND BG.SHBZ = '2'
        AND BG.ZBSHBZ = '0' AND D.SHEF = 'CN'
        and D.DWMC is not null
        and P.ZBFXMC = '资产负债率'
        and zj.TJBZ  = '1'
        and bg.SFZXPS = '1'
        and d.sfzr = '0'
        and NOT EXISTS(
        SELECT
        1
        FROM
        XTGHDW_YW_ZR_ZRPSFA_GYS G,
        XTGHDW_YW_ZR_ZJ_ZXDF Z,
        XTGHDW_YW_ZR_ZJ_ZXDFMX MX,
        XTGHDW_XT_JCSJ_DFMBMX MB
        WHERE
        G.GYSBM = D.DWBM
        AND G.ID = Z.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        AND Z.ID = MX.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        AND MX.DFBMMXID = MB.ID
        AND MB.VETO = 1
        AND MX.QT = 'no'
        )
        group by d.DWMC
        having avg(t.df) not in
        <foreach collection=zcfzlldfList item=item open=( separator=, close=)>
            #{item}
        </foreach>
        union all
        SELECT BG.ZRPSJGBM INVITENO,d.dwbm,d.DWMC ,
        max(d.YYZZ) YYZZ ,
        max(d.TJDWMC) TJDWMC ,
        max(d.TJDWBM) TJDWBM ,
        bg.SFZXPS psfs,
        D.SFZR,
        '回访记录栏得分应为（0、2、5）中的一种情形' yjyy
        FROM
        xtghdw_yw_zr_zj_zxdfmx t
        inner join xtghdw_yw_zr_zrpsfa_df df on df.id = t.XTGHDW_YW_ZR_ZRPSFA_DF_ID
        inner join xtghdw_yw_zr_zrpsfa f on DF.ZRPSFABM = F.ZRPSFABM
        inner join xtghdw_yw_zr_zj_zxdf zj on zj.ID  = t.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        inner join xtghdw_yw_zr_zrpsfa_gys gys on gys.ID  = zj.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        inner join xtghdw d on d.DWBM  = gys.GYSBM
        inner join b2b_ghdw_pfbz p on p.ghdwid = d.DWBM  and t.dfbmmxid  = p.dfmbmxid
        inner join XTGHDW_YW_ZR_ZRPSJG_BG BG on BG.ZRPSFABM  = F.ZRPSFABM and BG.GYSBM = gys.GYSBM
        where
        <if test=startTime != null>
            BG.SHSJ &gt;= #{startTime}
        </if>
        <if test=endTime != null>
            AND BG.SHSJ &lt;= #{endTime}
        </if>
        <if test=tyshxydm!=null>
            AND d.YYZZ = #{tyshxydm}
        </if>
        AND BG.SHBZ = '2'
        AND BG.ZBSHBZ = '0' AND D.SHEF = 'CN'
        and D.DWMC is not null
        and P.ZBFXMC = '回访记录'
        and bg.SFZXPS = '1'
        and d.sfzr = '0'
        and zj.TJBZ  = '1'
        and NOT EXISTS(
        SELECT
        1
        FROM
        XTGHDW_YW_ZR_ZRPSFA_GYS G,
        XTGHDW_YW_ZR_ZJ_ZXDF Z,
        XTGHDW_YW_ZR_ZJ_ZXDFMX MX,
        XTGHDW_XT_JCSJ_DFMBMX MB
        WHERE
        G.GYSBM = D.DWBM
        AND G.ID = Z.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        AND Z.ID = MX.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        AND MX.DFBMMXID = MB.ID
        AND MB.VETO = 1
        AND MX.QT = 'no'
        )
        group by d.DWMC
        having avg(t.df) not in
        <foreach collection=hfjlldfjhList item=item open=( separator=, close=)>
            #{item}
        </foreach>
        union all
        SELECT BG.ZRPSJGBM INVITENO,d.dwbm,d.DWMC ,
        max(d.YYZZ) YYZZ ,
        max(d.TJDWMC) TJDWMC ,
        max(d.TJDWBM) TJDWBM ,
        bg.SFZXPS psfs,
        D.SFZR,
        '现场服务记录栏得分应为（0、2、5）中的一种情形' yjyy
        FROM
        xtghdw_yw_zr_zj_zxdfmx t
        inner join xtghdw_yw_zr_zrpsfa_df df on df.id = t.XTGHDW_YW_ZR_ZRPSFA_DF_ID
        inner join xtghdw_yw_zr_zrpsfa f on DF.ZRPSFABM = F.ZRPSFABM
        inner join xtghdw_yw_zr_zj_zxdf zj on zj.ID  = t.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        inner join xtghdw_yw_zr_zrpsfa_gys gys on gys.ID  = zj.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        inner join xtghdw d on d.DWBM  = gys.GYSBM
        inner join b2b_ghdw_pfbz p on p.ghdwid = d.DWBM  and t.dfbmmxid  = p.dfmbmxid
        inner join XTGHDW_YW_ZR_ZRPSJG_BG BG on BG.ZRPSFABM  = F.ZRPSFABM and BG.GYSBM = gys.GYSBM
        where
        <if test=startTime != null>
            BG.SHSJ &gt;= #{startTime}
        </if>
        <if test=endTime != null>
            AND BG.SHSJ &lt;= #{endTime}
        </if>
        <if test=tyshxydm!=null>
            AND d.YYZZ = #{tyshxydm}
        </if>
        AND BG.SHBZ = '2'
        AND BG.ZBSHBZ = '0' AND D.SHEF = 'CN'
        and D.DWMC is not null
        and P.ZBFXMC in('客户现场服务记录','现场服务记录')
        and zj.TJBZ  = '1'
        and bg.SFZXPS = '1'
        and d.sfzr = '0'
        and NOT EXISTS(
        SELECT
        1
        FROM
        XTGHDW_YW_ZR_ZRPSFA_GYS G,
        XTGHDW_YW_ZR_ZJ_ZXDF Z,
        XTGHDW_YW_ZR_ZJ_ZXDFMX MX,
        XTGHDW_XT_JCSJ_DFMBMX MB
        WHERE
        G.GYSBM = D.DWBM
        AND G.ID = Z.XTGHDW_YW_ZR_ZRPSFA_GYS_ID
        AND Z.ID = MX.XTGHDW_YW_ZR_ZJ_ZXDF_ID
        AND MX.DFBMMXID = MB.ID
        AND MB.VETO = 1
        AND MX.QT = 'no'
        )
        group by d.DWMC
        having avg(t.df) not in
        <foreach collection=xcfwjlldfList item=item open=( separator=, close=)>
            #{item}
        </foreach>
        ) tt group by tt.dwmc
        
        
        
        
        

        and F.SHSJ >= '2024-08-01'
        -- #{startTime} <if test=startTime != null>
        and F.SHSJ <= '2024-08-01'
        -- #{endTime} <if test=endTime != null>
        and d.YYZZ = 'xxx'
        -- #{tyshxydm} <if test=tyshxydm!=null>
        
        