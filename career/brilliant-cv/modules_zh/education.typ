// Imports
#import "@preview/brilliant-cv:2.0.5": cvSection, cvEntry, hBar
#let metadata = toml("../metadata_zh.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("教育经历")

#cvEntry(
  title: [计算机科学硕士],
  society: [清华大学],
  date: [2007 - 2011],
  location: [北京、深圳],
  logo: image("../src/logos/清华大学-logo.svg"),
  description: list(
  //  [论文: 使用机器学习算法和网络分析预测电信行业的客户流失],
  //  [课程: 大数据系统与技术 #hBar() 数据挖掘与探索 #hBar() 自然语言处理],
  ),
)

#cvEntry(
  title: [计算机科学学士],
  society: [清华大学],
  date: [2014 - 2018],
  location: [北京],
  logo: image("../src/logos/清华大学-logo.svg"),
  description: list(
  //  [论文: 探索使用机器学习算法预测股票价格: 回归与时间序列模型的比较研究],
  //  [课程: 数据库系统 #hBar() 计算机网络 #hBar() 软件工程 #hBar() 人工智能],
  ),
)
