#import "template.typ": template, menu

#set text(
  font: "FangSong", 
  size: 14pt,
  lang: "zh"
)

#show strong: it => text(font: "SimHei", it.body)

#grid(
  columns: (0.8em, auto),
  grid.vline(
    x: 0, 
    end: 2, 
    stroke: 10pt + blue),
  [], [五矿集团“数字化企业大脑”项目\
  数据治理文档]
)

#v(30%)

#align(center, text(30pt)[
  *人力资源数据建模*\
  （草稿）
])

#align(right + bottom,
    datetime.today().display("[year]年[month]月[day]日更新"))

#pagebreak()

#show: template

#outline()

#set page(numbering: "1")
#counter(page).update(1)

#pagebreak()


= 应用层（ADS）设计

依照“数字化企业大脑大屏”中“人力资源”项下的页面梳理ADS层的数据模型。ADS层表的设计原则为：

+ 每个一级菜单页面中的数值结果归集到一张表来管理。
  - #menu([人才管理])页面：`ADS_HR_TALENT`
  - #menu([干部管理])页面：`ADS_HR_CADRE`
  - #menu([薪酬效能])页面：`ADS_HR_RENUMERATION`
+ 每个数值结果表依据具体情况，可能包括以下字段：
  - 年份、日期等。
  - 直管企业代码、名称。
  - 一些列的topic，对应数值的“菜单路径”。如：#menu([技能人才队伍], [年龄分布], [46岁至50岁])对应：
    - `topic_1` = 技能人才队伍
    - `topic_2` = 年龄分布
    - `topic_3` = 46岁至50岁
  - 该数值本身。用`double precision`数据类型存储以兼容整数、小数和比率等结果。如：22.05% = 0.2205。
+ 非数值型的结果（如企业列表等），专门创建ADS表。


== 人才管理

#figure(
  image("resource/人才管理.png"),
  caption: [人才管理],
) <人才管理>

人才管理表
```sql
create table ADS_HR_TALENT (
  topic_1 text,
  topic_2 text,
  topic_3 text,
  biz_year date comment '年份'     -- '2024-01-01'
  quantity double precision,
  org_code text,
  org_name text comment '直管企业'  -- '五矿国际'
)
```

=== 人才概况

- topic_1：人才概况
  - topic_2：职工人数
  - topic_2：从业人数
  - topic_2：在岗职工
    - topic_3：五矿集团
    - topic_3：直管企业
  - topic_2：劳务派遣占比

点击#menu([人才概况],[从业人数])，显示“近十年人员变化总量”（@fig:近十年人员变化总量）。

#figure(
  image("resource/近十年人员变化总量.png"),
  caption: [近十年人员变化总量],
) <近十年人员变化总量>

点击#menu([人才概况],[在岗职工])，显示“在岗职工详情”（@fig:在岗职工详情）。

#figure(
  image("resource/在岗职工详情.png"),
  caption: [在岗职工详情],
) <在岗职工详情>


其中对“从业”、“职工”、“在岗”等分类的理解如下：

- 从业人员：指所有参与五矿集团经济活动并从中获得收入的人员总数。包含职工和劳务派遣人员等。
  - 职工：与五矿集团或其子公司有正式雇佣关系的员工数量。不包括劳务派遣人员等。
    - 在岗职工：指那些正在执行工作任务、参与日常运营的职工。
  - 劳务派遣人员。



- 经营管理维度：
  - 党组管理的领导干部（高级）
  - 党委管理的领导干部
  - 其他经营管理人员

=== 科技人才队伍

- topic_1：科技人才队伍


科技人才的分类如下。

  - 杰出人才（高级）
    - 国外顶尖人才
    - 国家级杰出人才
  - 领军人才
    - 集团领军人才
    - 企业领军人才
  - 骨干人才
    - 企业骨干人才
    - 青年骨干人才
    - 其他科技人才

=== 技能人才队伍

- topic_1：技能人才队伍


技能人才的分类如下。

  - 高级技能人才
    - 高级技师
    - 技师
    - 高级工
  - 中级工 
  - 初级工
  - 普通工


=== 人才预警

- topic_1：人才预警


=== 职业技能等级认证

- topic_1：职业技能等级认证

=== 员工培训整体情况

- topic_1：员工培训整体情况



以上这些分类汇总结果使用人员概览表实现（@ADS_WORKFORCE_OVERVIEW）。

#let ADS_WORKFORCE_BREAKDOWN = csv("data/ADS_WORKFORCE_OVERVIEW.csv")

#figure(
  table(
    columns: ADS_WORKFORCE_BREAKDOWN.first().len(),
    align: horizon + left,
    fill: (_, y) => if y == 0 {gray},
    ..ADS_WORKFORCE_BREAKDOWN.flatten()
  ), // caption: [应用层表：人员概览（ADS_WORKFORCE_OVERVIEW）]
) <ADS_WORKFORCE_OVERVIEW>



== 干部管理

#figure(
  image("resource/干部管理.png"),
  caption: [干部管理],
) <干部管理>


== 干部监督

== 薪酬效能

#figure(
  image("resource/薪酬效能.png"),
  caption: [薪酬效能],
) <薪酬效能>


= 贴源层（ODS）设计
