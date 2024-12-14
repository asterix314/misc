-- 主数据

create table DIM_ORG_PATH(
    org_cd VARCHAR(255) not null comment '组织机构代码',
    org_typ VARCHAR(255) comment '组织机构类型',
    virt_entt BOOLEAN comment '是否虚拟部门',    
    org_cn_nm VARCHAR(255) comment '组织机构全称',
    org_cn_abbr VARCHAR(255) comment '组织机构简称',
    entp_typ VARCHAR(255) comment '企业类型',
    reg_typ VARCHAR(255) comment '登记注册类型',    
    unit_soci_crdt_cd VARCHAR(255) comment '统一社会信用代码',
    reg_no VARCHAR(255) comment '工商注册登记号',
    natn_org_cd VARCHAR(255) comment '全国组织机构代码',
    vat_no VARCHAR(255) comment '纳税人登记号',
    oth_valid_no VARCHAR(255) comment '其他有效证件号',
    cnty VARCHAR(255) comment '国家',
    prvn VARCHAR(255) comment '省份/直辖市',
    city VARCHAR(255) comment '城市',
    town VARCHAR(255) comment '区县',
    legl_respn_ps VARCHAR(255) comment '法定代表人/负责人',
    reg_addr VARCHAR(6000) comment '注册地址',
    post_cd VARCHAR(255) comment '邮政编码',
    upr_mng VARCHAR(255) comment '上级管理单位',
    mng_prox VARCHAR(255) comment '管理组织排序码',
    grp_diret_mng_entp VARCHAR(255) comment '所属直管企业',
    equt_typ VARCHAR(255) comment '股权属性',
    opert_sts VARCHAR(255) comment '经营状态',
    upr_hr_mng VARCHAR(255) comment '上级人事单位',
    hr_mng_prox VARCHAR(255) comment '人事组织排序码',
    upr_equt_mng VARCHAR(255) comment '上级股权单位',
    equt_mng_prox VARCHAR(255) comment '股权组织排序码',
    path_mng array<VARCHAR(255)> comment '管理层级路径',
    path_hr array<VARCHAR(255)> comment '人事层级路径',
    path_equt array<VARCHAR(255)> comment '股权层级路径'
) ENGINE=OLAP
UNIQUE KEY(`org_cd`)
COMMENT '组织机构主数据标准'
DISTRIBUTED BY HASH(`org_cd`) BUCKETS 1;


-- currently the data for DIM_ORG_PATH come from XLSX files still not fully completed.
-- run the following from duckdb and export to doris/DIM_ORG_PATH
-- or alternatively as part of an ETL task configured on SISDI's data governence platform.
insert into DIM_ORG_PATH
with recursive ods as (
    select '人事树' as src, *
    from st_read('D:\misc\minmetals\人力资源\人事树20241130.XLSX', layer='Sheet1', open_options=['headers=force', 'field_types=string'])
    union all by name
    select '管理树' as src, *
    from st_read('D:\misc\minmetals\人力资源\管理树20241130.XLSX', layer='Sheet1', open_options=['headers=force', 'field_types=string'])
    union all by name
    select '股权树' as src, *
    from st_read('D:\misc\minmetals\人力资源\股权树20241130.XLSX', layer='Sheet1', open_options=['headers=force', 'field_types=string'])),
org as (
    select 
        trim(组织机构代码) as org_cd, -- 组织机构代码
        any_value(nullif(trim(组织机构类型), '')) as org_typ, -- 组织机构类型
        any_value(trim(是否虚拟部门) = '1') as virt_entt, -- 是否虚拟部门
        any_value(nullif(trim(组织机构全称), '')) as org_cn_nm, -- 组织机构全称
        any_value(nullif(trim(组织机构简称), '')) as org_cn_abbr, -- 组织机构简称
        any_value(nullif(trim(企业类型), '')) as entp_typ, -- 企业类型
        any_value(nullif(trim(登记注册类型), '')) as reg_typ, -- 登记注册类型
        any_value(nullif(trim(统一社会信用代码), '')) as unit_soci_crdt_cd, -- 统一社会信用代码
        any_value(nullif(trim(工商注册登记号), '')) as reg_no, -- 工商注册登记号
        any_value(nullif(trim(全国组织机构代码), '')) as natn_org_cd, -- 全国组织机构代码
        any_value(nullif(trim(纳税人登记号), '')) as vat_no, -- 纳税人登记号
        any_value(nullif(trim(其他有效证件), '')) as oth_valid_no, -- 其他有效证件号
        any_value(nullif(trim(国家), '')) as cnty, -- 国家
        any_value(nullif(trim("省份/直辖市"), '')) as prvn, -- 省份/直辖市
        any_value(nullif(trim(城市), '')) as city, -- 城市
        any_value(nullif(trim(区县), '')) as town, -- 区县        
        any_value(nullif(trim("法定代表人/负责人"), '')) as legl_respn_ps, -- 法定代表人/负责人
        any_value(nullif(trim(注册地址), '')) as reg_addr, -- 注册地址
        any_value(nullif(trim(邮政编码), '')) as post_cd, -- 邮政编码
        any_value(nullif(trim(上级管理单位), '')) as upr_mng, -- 上级管理单位
        any_value(nullif(trim(管理组织排序码), '')) as mng_prox, -- 管理组织排序码
        any_value(nullif(trim(所属直管企业), '')) as grp_diret_mng_entp, -- 所属直管企业
        any_value(nullif(trim(股权属性), '')) as equt_typ, -- 股权属性
        any_value(nullif(trim(经营状态), '')) as opert_sts, -- 经营状态
        any_value(nullif(trim(上级人事单位), '')) as upr_hr_mng, -- 上级人事单位
        any_value(nullif(trim(人事组织排序码), '')) as hr_mng_prox, -- 人事组织排序码
        any_value(nullif(trim(上级股权单位), '')) as upr_equt_mng, -- 上级股权单位
        any_value(nullif(trim(股权组织排序码), '')) as equt_mng_prox -- 股权组织排序码
    from ods
    where trim(组织机构代码) != ''
    group by org_cd),
mng(org_cd, p) as (
    select '60000001', ['60000001']
    union all
    select org.org_cd, list_append(h.p, org.org_cd)
    from org inner join mng as h
        on org.upr_mng = h.org_cd),
hr(org_cd, p) as (
    select '60000001', ['60000001']
    union all
    select org.org_cd, list_append(h.p, org.org_cd)
    from org inner join hr as h
        on org.upr_hr_mng = h.org_cd),
equt(org_cd, p) as (
    select '60000001', ['60000001']
    union all
    select org.org_cd, list_append(h.p, org.org_cd)
    from org inner join equt as h
        on org.upr_equt_mng = h.org_cd),
org_ex as (
    select org.*, 
        mng.p as path_mng, 
        hr.p as path_hr, 
        equt.p as path_equt
    from org left join mng using (org_cd)
        left join hr using (org_cd)
        left join equt using (org_cd))
from org_ex
