#import "模板.typ": 模板

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
  *数据治理产品操作规范*\
  （草稿）
])

#align(right + bottom,
    datetime.today().display("[year]年[month]月[day]日更新"))

#pagebreak()

#show: 模板

#outline()

#set page(numbering: "1")
#counter(page).update(1)

#pagebreak()


#include "项目配置.typ"

#include "外部数据同步.typ"

#include "数据建模.typ"

#include "数据开发.typ"

#include "运维监控.typ"

