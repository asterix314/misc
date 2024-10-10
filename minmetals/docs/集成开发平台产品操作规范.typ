#set text(
  font: "FangSong", 
  size: 14pt,
  lang: "zh"
)

#set heading(numbering: "1.1")

#show heading.where(
  level: 1
): it => block(width: 100%)[
  #set align(center)
  #set text(16pt, font: "SimHei")
  #it
]

#show heading: set block(spacing: 1.2em)
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
    datetime.today().display("[year] 年 [month] 月 [day] 日更新"))

#show table.cell.where(y: 0): set text(weight: "bold")

#pagebreak()

#set page(
  header: [#align(right, text(font: "FangSong", baseline: 8pt)[
          集成开发平台产品操作规范])
      #line(length: 100%)]
)

#outline()

#set text(
  font: ("Times New Roman", "SimSun"), 
  size: 12pt,
  lang: "zh"
)

#set page(
  numbering: "1",
)

#set par(justify: true)

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}

#let 菜单(m1, m2) = {
  set text(font: "SimHei")
  [#m1 #text(size: 16pt, [▶]) #m2]
}

// 段落首行缩进
#show: body => {
  for (ie, elem) in body.children.enumerate() {
    if elem.func() == text {
      if ie > 0 and body.children.at(ie - 1).func() == parbreak {
        h(2em)
      }
      elem
    } else {
      elem
    }
  }
}

#counter(page).update(1)

数据集成与开发旨在帮助企业解决日益复杂的数据采集与利用问题，其核心功能是整合来自不同源头、格式各异的数据资源，通过抽取、转换、加载等一系列过程，最终输出满足业务需要的数据，为上层数据应用赋能。 

该平台主要面向数据开发人员，为其提供可视化的数据开发界面，简化数据加工流程的设计与构建，使得开发团队能够快速响应业务需求变化，实施数据项目，加速数据分析和应用开发的进程。主要涵盖多源异构数据采集、数据流水线编排、数据任务的开发调试与调度、版本控制、运维监控、性能优化等全方位的功能，为企业的数据驱动战略奠定坚实基础。

一些名词解释：

/ 数据任务：: 定义数据同步或数据加工的逻辑，实际执行数据的同步或加工动作。

/ 数据流水线：: 将多个数据同步或加工任务，按执行顺序编排而成的数据加工流程。

/ 实时数据同步：:	当来源数据库发生数据变化时，即时同步数据到目标数据库中。

/ 离线数据同步：:	通常一次性、或按照一定的时间间隔，将批量的数据同步到目标数据库。

/ 任务调度：: 在复杂的数据处理流程中，自动化地组织和管理各个数据处理任务的执行顺序、依赖关系、计算资源，提高数据处理的效率和准确性，减少人工干预和错误。

/ 数据开发：:	数据开发关注从原始数据中获取有价值的信息，通过可视化配置或代码编程等方式，创建对数据做清洗、转换、聚合的自动化任务，并编排各任务间的数据处理流程。

= 项目配置

在使用平台进行开发之前，首先需要对项目进行配置。

== 项目空间

项目空间是任务的容器。不同项目空间的任务是不可见的。在集成开发平台中，如需创建数据同步、数据加工等任务，均需在已授权的项目空间下进行。用户可根据需要切换所在项目空间。*如无特殊情况，应使用“正式环境”项目空间*，如@正式环境 所示。

#figure(
  rect(image("img/正式环境.png", width: 80%)),
  caption: [“正式环境”项目空间],
  placement: none
) <正式环境>

项目空间主要有以下配置项：

+ 项目名称：项目的名称。

+ 描述：项目简介。

+ 主负责人：按需设置即可。

+ Worker资源组：选择“生产环境-worker集群”。可在页面 #菜单([运维中心], [工作集群监控])中查看计算资源配置。

+ 开发模式：

  - 简单模式：开发和生产一体的项目开发模式，数仓引擎只对应生产环境一个数据源，数据加工任务的调试运行、调度运行都是操作生产环境的数据，创建的表和数据也只有一份。如果您追求极致的数据开发效率，且数据计算和存储资源有限，推荐此模式。

  - 标准模式（“正式环境”项目空间使用此模式）：开发和生产环境隔离的项目开发模式，数仓引擎可绑定开发和生产两个数据源，数据加工任务在调试运行时只操作开发环境的数据，在发布后调度运行时才操作生产环境数据。该模式下的库表和数据，通常需要在开发和生产环境各自创建一份，如果您对数据开发过程中的数据安全、流程规范有较高要求，且数据计算和存储资源充足，推荐此模式。

+ 权限模式：

  - 不允许他人修改：除项目负责人、平台管理员以及超级管理员外，同空间内自己创建的集成、开发任务只有自己能编辑、删除、上线、下线、提交发布、试运行及暂停。

  - 任务允许他人修改：同空间的集成、开发任务允许访客之外的其他成员修改，包括编辑、上线、下线、提交发布、试运行及暂停，但不包括删除（创建者、项目负责人、空间管理员和超级管理员可以删除）。

如需创建项目空间，需具备高级权限，建议联系平台管理员创建并授权，或联系管理员先将用户授权为“平台管理员”角色后自行创建项目空间。

#figure(
  rect(image("img/创建项目空间.png", width: 80%)),
  caption: [创建项目空间],
  placement: none
) <创建项目空间>

+ 进入 #菜单([配置中心],[项目空间]) 页面，点击右上角新建项目空间按钮。

+ 授权项目空间给用户。若在创建项目空间时已经指定了自己为主负责人，无需再执行授权操作。若需将已有项目空间授权给自己或其它人。进入 #菜单([配置中心],[项目空间]) 页面后，选择对应项目空间名称，点击设置按钮。

== 成员角色（TODO）

== 数据源（TODO）

= 外部数据同步（TODO）

== 实时同步

== 定时同步

= 数据建模（TODO）

== 数仓规划


== 模型设计与逆向建模

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

= 数据开发(TODO)


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


= 运维监控

在“运维中心”可以监控各任务运行的情况、浏览任务报错日志、启动、停止任务等。此外，还可以监控整个“集成开发平台”产品运行节点的健康状况。

== 任务监控

#figure(
  rect(image("img/实时集成日志.png", width: 80%)),
  caption: [实时集成日志],
  placement: none
) <实时集成日志>


平台对数据集成（实时、离线）和数据加工任务都可以分别进行监控。

- 对实时集成任务，重点关注异常日志。如果错误是暂时性的（如@实时集成日志），可以不必理会，因为 CDC 任务会在后续的成功同步中弥补缺失。
- 对离线集成和数据加工任务，须关注最近一个时段的失败任务。用筛选条件查询（如@数据加工失败任务查询），再查看失败任务的日志。

注意：如果任务频率较高（如每分钟都运行），则系统会积累下大量的运行记录和日志，造成后续查询缓慢甚至无法查询。目前的解决方案是只查最近时段（如最近一小时）且状态为“失败”的任务。

#figure(
  rect(image("img/数据加工失败任务查询.png", width: 80%)),
  caption: [数据加工失败任务查询],
  placement: none
) <数据加工失败任务查询>


== 集群监控

#figure(
  rect(image("img/集群监控.png", width: 80%)),
  caption: [集群监控],
  placement: none
) <集群监控>

集群监控的页面如@集群监控 所示。 需要注意的是，无论是调度集群还是工作集群，*监控的对象都是产品功能的运行节点，而不是业务数据的存储节点*。也就是说，@集群监控 中那几百G的“磁盘可用空间”不是 doris 数据存储的磁盘空间。这些节点执行调度任务、转发任务，以及 python、shell 这些任务也都会在上面运行。占用磁盘空间的主要是系统日志文件等。

当任务监控界面出现报错或无法查询等异常时，不妨浏览一下集群监控界面，看有没有异常（高CPU使用率或内存占用、磁盘可用量枯竭等），或许可以为定位问题提供一些提示。


