#import "template.typ": template, menu

#show: template

= 产品概览

数据集成与开发旨在帮助企业解决日益复杂的数据采集与利用问题，其核心功能是整合来自不同源头、格式各异的数据资源，通过抽取、转换、加载等一系列过程，最终输出满足业务需要的数据，为上层数据应用赋能。 

该平台主要面向数据开发人员，为其提供可视化的数据开发界面，简化数据加工流程的设计与构建，使得开发团队能够快速响应业务需求变化，实施数据项目，加速数据分析和应用开发的进程。主要涵盖多源异构数据采集、数据流水线编排、数据任务的开发调试与调度、版本控制、运维监控、性能优化等全方位的功能，为企业的数据驱动战略奠定坚实基础。

一些名词解释：

/ 数据任务：: 定义数据同步或数据加工的逻辑，实际执行数据的同步或加工动作。

/ 数据流水线：: 将多个数据同步或加工任务，按执行顺序编排而成的数据加工流程。

/ 实时数据同步：:	当来源数据库发生数据变化时，即时同步数据到目标数据库中。

/ 离线数据同步：:	通常一次性、或按照一定的时间间隔，将批量的数据同步到目标数据库。

/ 任务调度：: 在复杂的数据处理流程中，自动化地组织和管理各个数据处理任务的执行顺序、依赖关系、计算资源，提高数据处理的效率和准确性，减少人工干预和错误。

/ 数据开发：:	数据开发关注从原始数据中获取有价值的信息，通过可视化配置或代码编程等方式，创建对数据做清洗、转换、聚合的自动化任务，并编排各任务间的数据处理流程。

/ 变更数据捕获（CDC）：: 通过监控数据库日志或其他机制，捕捉到数据的每一次变化（增删改操作），然后将这些变化以结构化的方式提供给下游系统，如数据仓库、消息队列、流处理引擎等，实现数据的实时同步和分析。

/ 数仓分层：:	数仓分层是对数仓的表进行组织管理的技术维度，用于将不同用途的数据表，归类划分至不同的分层，便于更好地组织、管理、维护模型数据表。

/ 主题域：:	主题域是对贴源层和公共层数据表和视图进行组织和管理的维度，是根据业务分析对业务过程进行抽象的集合，一般一个主题域下的数据表均存在一定的关系

/ 应用域：:	应用域是面向应用场景或产品的数据组织，是对应用层的数据表进行组织和管理的维度，一般一个应用域下的数据表均存在一定的关系

/ 明细模型：:	明细模型（Duplicate）在某些多维分析场景下，数据既没有主键，也没有聚合需求，针对这种需求，可以使用明细数据模型

/ 唯一模型：:	当用户有数据更新需求时，可以选择使用唯一模型（Unique）。唯一模型能够保证 Key（主键）的唯一性，当用户更新一条数据时，新写入的数据会覆盖具有相同 key（主键）的旧数据

/ 聚合模型：:	聚合模型（Aggregate），当我们导入数据的时候, 会按照 key 对 value 使用他们自己的聚合类型进行聚合，经过聚合，Doris 中最终只会存储聚合后的数据。

/ 分区：:	分区用于将数据划分成不同区间，可以理解成把原始表划分成多个子表。可以方便的按分区对数据进行管理。分区可以视为是逻辑上最小的管理单元。

/ 分桶：:	分桶用于将数据划分为若干个数据分片，每个分桶包含若干数据行，各个分桶之间的数据相互独立。一个分桶只属于一个分区，但一个分区可以包含若干个分桶。分桶是数据移动、复制等操作的最小物理存储单元。
