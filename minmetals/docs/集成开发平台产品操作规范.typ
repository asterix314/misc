#set text(
  font: "FangSong", 
  size: 14pt,
  lang: "zh"
)

#set heading(numbering: "1.1")
#show raw: set text(font: ("Fira Code", "FangSong"))
#show strong: it => text(font: "SimHei", it.body)

#grid(
  columns: (0.8em, auto),
  grid.vline(
    x: 0, 
    end: 2, 
    stroke: 10pt + blue),
  [],
)[五矿集团“数字化企业大脑”项目\
数据治理文档]

#v(30%)

#align(center, text(30pt)[
  *集成开发平台产品操作规范*\
  （草稿）
])

#align(right + bottom,
    datetime.today().display("[year] 年 [month] 月 [day] 日"))

#show table.cell.where(y: 0): set text(weight: "bold")

#pagebreak()


#set page(
  header: [#align(right, text(font: "FangSong", baseline: 8pt)[
          集成开发平台产品操作规范])
      #line(length: 100%)]
)

#outline()

#pagebreak()

#set text(
  font: ("Times New Roman", "SimSun"), 
  size: 12pt,
  lang: "zh"
)

#set page(
  numbering: "1",
)

#counter(page).update(1)

数据集成与开发旨在帮助企业解决日益复杂的数据采集与利用问题，其核心功能是整合来自不同源头、格式各异的数据资源，通过抽取、转换、加载等一系列过程，最终输出满足业务需要的数据，为上层数据应用赋能。 

该平台主要面向数据开发人员，为其提供可视化的数据开发界面，简化数据加工流程的设计与构建，使得开发团队能够快速响应业务需求变化，实施数据项目，加速数据分析和应用开发的进程。主要涵盖多源异构数据采集、数据流水线编排、数据任务的开发调试与调度、版本控制、运维监控、性能优化等全方位的功能，为企业的数据驱动战略奠定坚实基础。

名词解释：

/ 数据任务: 定义数据同步或数据加工的逻辑，实际执行数据的同步或加工动作。

/ 数据流水线: 将多个数据同步或加工任务，按执行顺序编排而成的数据加工流程。

/ 实时数据同步:	当来源数据库发生数据变化时，即时同步数据到目标数据库中。

/ 离线数据同步:	通常一次性、或按照一定的时间间隔，将批量的数据同步到目标数据库。

/ 任务调度: 在复杂的数据处理流程中，自动化地组织和管理各个数据处理任务的执行顺序、依赖关系、计算资源，提高数据处理的效率和准确性，减少人工干预和错误。

/ 数据开发:	数据开发关注从原始数据中获取有价值的信息，通过可视化配置或代码编程等方式，创建对数据做清洗、转换、聚合的自动化任务，并编排各任务间的数据处理流程。

/ 数据孤岛:	在企业内部或外部，数据被分散存储在不同的系统或部门中，无法实现共享和整合，导致数据的价值无法得到充分利用。

/ 数据仓库:	传统事务型数据库在数据组织模式、存储容量、查询效率等方面，通常难以支撑大规模数据下的分析型需求。数据仓库（Data Warehouse）通常以业务主题的视角来组织数据，集中存储海量原始数据和转换后的数据，结合高性能的平台引擎为数据应用提供可靠服务。

= 配置中心

== 项目空间

在集成开发平台中，如需创建数据同步任务、数据加工任务，均需在已授权的项目空间下进行。用户可根据需要切换所在项目空间。

#figure(
  image("img/创建项目空间.png", width: 80%),
  caption: [创建项目空间],
  placement: auto
) <创建项目空间>


== 成员角色

== 数据源

= 数据集成

== 实时同步

== 定时同步

= 数据建模

@员工表 展示了员工表的一些重要字段。

#let DWS_EMPLOYEE = csv("data/DWS_EMPLOYEE.csv")

#figure(
  table(
    columns: DWS_EMPLOYEE.first().len(),
    align: horizon + left,
    fill: (_, y) => if y == 0 {gray},
    ..DWS_EMPLOYEE.flatten()
  ), caption: [员工表（EMPLOYEE）]
) <员工表>



= 数据开发




```sql
-- 数据导入模板

-- 数据表基本信息
-- 唯一模型、不分区、分桶数量随表增长。
with t as (
    select if(table_name ilike 'cg\_%' escape '\', 'dwd_', 'dwd_cg_') as prefix, *
    from table_info
    where
        table_schema = 'mcc'
    and (
        table_name like 'cg%'
        or table_name like 'xtghdw%'
        or table_name like 'ztb%'))
select
    upper(prefix || table_name) as "表英文名称",
    coalesce(
        nullif(trim(table_comment), ''),
        upper(prefix || table_name)) as "描述",
    '唯一模型' as "表聚合类型",
    '不分区' as "分区策略",
    '' as "分区字段",
    '' as "分区时间粒度",
    '' as "保留最近分区数",
    '' as "提前创建未来分区数",
    '' as "初始化历史分区数",
    '' as "分桶字段",
    floor(1 + table_rows/5e6) as "分桶数量"
from t
```