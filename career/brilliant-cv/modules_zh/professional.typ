// Imports
#import "@preview/brilliant-cv:2.0.4": cvSection, cvEntry
#let metadata = toml("../metadata_zh.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("职业经历")

#cvEntry(
  title: [数据科学家],
  society: [思码逸科技],
  logo: image("../src/logos/merico-logo.png"),
  date: [2021年12月 - 2023年6月],
  location: [北京],
  description: list(
    [设计并开发了一套高效的后端系统，该系统能够对开发团队的工作效率进行深入评估和解读。利用先进的数据分析技术，为团队提供了定制化的效率提升方案。],
    [参与了基于ChatGPT的内部项目，开发了资料问答系统，增强了团队的知识管理和信息检索能力。],
    [从零开始搭建了客户数据分析平台，包括数据建模和指标体系规范化。],
    [定期产出行业基线报告，为客户提供了宝贵的市场洞察和决策支持。]
  ),
  tags: ("专家系统", "大语言模型", "PostgreSQL", "Python", "基线报告"),
)

#cvEntry(
  title: [数据分析师],
  society: [ABC 公司],
  logo: image("../src/logos/abc_company.png"),
  date: [2017 - 2020],
  location: [纽约, NY],
  description: list(
    [使用 SQL 和 Python 分析大型数据集，与团队合作发现商业洞见],
    [使用 Tableau 创建数据可视化和仪表板，使用 AWS 开发和维护数据管道],
  ),
)

#cvEntry(
  title: [数据分析实习生],
  society: [PQR 公司],
  logo: image("../src/logos/pqr_corp.png"),
  date: list(
    [2017年夏季],
    [2016年夏季],
  ),
  location: [芝加哥, IL],
  description: list([协助使用 Python 和 Excel 进行数据清洗、处理和分析，参与团队会议并为项目规划和执行做出贡献]),
)
