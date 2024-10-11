

-- execute on doris for 数据表基本信息 sheet of 司法大数据表导入模板.xlsx
select
    replace(upper(table_name), '_', '_FL_') as "表英文名称",
    '' as "描述",
    '唯一模型' as "表聚合类型",
    '不分区' as "分区策略",
    '' as "分区字段",
    '' as "分区时间粒度",
    '' as "保留最近分区数",
    '' as "提前创建未来分区数",
    '' as "初始化历史分区数",
    '' as "分桶字段",
    '' as "分桶数量"
from information_schema.tables
where table_schema = 'dw_ods_dsep' and table_name like 'ODS_xzla%'


-- execute on doris for 表字段信息 sheet of 司法大数据表导入模板.xlsx
select
    replace(upper(table_name), '_', '_FL_') as "表英文名称",
    ordinal_position as "字段顺序号",
    lower(column_name) as "字段英文名称",
    coalesce(nullif(trim(column_comment), ''), lower(column_name)) as "字段描述",
    data_type as "字段类型",
    case upper(data_type)
        when 'VARCHAR' then '65533'
        else ''
    end as "长度",
    '' as "精度",
    if(upper(column_key)='UNI', '是', '否') as "Key 列",
    '' as "聚合类型",
    if(is_nullable='NO', '是', '否') as "非空"
from information_schema.`columns` c 
where table_schema = 'dw_ods_dsep' and table_name like 'ODS_xzla%'
