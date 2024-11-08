// 基础字体设定
#set page(paper: "a4")
#set text(font: "SimSun", size: 12pt, lang: "zh")


五矿集团“数字化企业大脑”项目 \
数据治理文档

#v(30%)

#align(center, text(26pt, font: "SimHei")[
  *人力资源系统数据建模*\
  （草稿）
])

#align(right + bottom, 
  datetime.today().display("[year] 年 [month] 月 [day] 日"))

#show table.cell.where(y: 0): set text(weight: "bold")

#pagebreak()

= 应用层（ADS）设计

综合“数字化企业大脑”中人力资源相关的页面，可总结出 ADS 层应该满足如下几个方面的应用需求。


== 人力资源概览

这部分主要提供员工人数的分布情况。分布的维度为：

- 劳动关系（@概览-人数分布图）
- 年龄、性别、学历（@概览-人数分布图）
- 直管单位（@概览-人数按直管企业分布图）
- 年份（@概览-人员近年变化情况图）

其中对“从业”、“职工”、“在岗”等分类的理解如下：

- 从业人员：指所有参与五矿集团经济活动并从中获得收入的人员总数。包含职工和劳务派遣人员等。
  - 职工：与五矿集团或其子公司有正式雇佣关系的员工数量。不包括劳务派遣人员等。
    - 在岗职工：指那些正在执行工作任务、参与日常运营的职工。
  - 劳务派遣人员。

#figure(
  image("resource/人数分布.png", width: 60%),
  caption: [概览：人数分布],
  placement: auto
) <概览-人数分布图>


#figure(
  image("resource/人数按直管企业分布.png", width: 60%),
  caption: [概览：人数按直管企业分布],
  placement: auto
) <概览-人数按直管企业分布图>

#figure(
  image("resource/人员近年变化情况.png", width: 60%),
  caption: [人员近年变化情况],
  placement: auto
) <概览-人员近年变化情况图>

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


== 人才管理

=== 人才概况


```sql
select * 
from DWS_TEST

```

=== 技能人才

技能人才的分类如下。

  - 高级技能人才
    - 高级技师
    - 技师
    - 高级工
  - 中级工 
  - 初级工
  - 普通工

=== 科技人才

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



- 经营管理维度：
  - 党组管理的领导干部（高级）
  - 党委管理的领导干部
  - 其他经营管理人员


== 干部管理

== 薪酬效能

== 禁止交易

== 基础信息

= 服务层（DWS）设计


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


= 贴源层（ODS）设计



= 标准层（DWD）设计
