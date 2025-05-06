// Imports
#import "@preview/brilliant-cv:2.0.4": cvSection, cvEntry, hBar
#let metadata = toml("../metadata_zh.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("教育经历")

#cvEntry(
  title: [计算机科学硕士],
  society: [清华大学网络所],
  date: [2007 - 2011],
  location: [北京、深圳],
  logo: image("../src/logos/清华大学-logo.svg"),
  description: list(
//  [论文: 使用机器学习算法和网络分析预测电信行业的客户流失],
  [课程: 组合数学 #hBar() 计算机网络体系结构 #hBar() 无线网络与移动计算 #hBar() 密码学与网络安全 #hBar() 多媒体计算机技术 #hBar() 人工智能原理],
  ),
)

#cvEntry(
  title: [物理学学士],
  society: [清华大学],
  date: [2014 - 2018],
  location: [北京],
  logo: image("../src/logos/清华大学-logo.svg"),
  description: list(
//  [论文: 探索使用机器学习算法预测股票价格: 回归与时间序列模型的比较研究],
  [课程: 几何与代数 #hBar() 复变函数 #hBar() 理论力学 #hBar() 数理方程 #hBar() 量子力学 #hBar() 电动力学 #hBar() 计算物理 #hBar() 天体物理],
  ),
)
