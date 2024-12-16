#set page(
  "a4",
  margin: (x: 5em, y: 4em),
  flipped: true,
  columns: 2
)

#let data = toml("古诗词.toml")

#let i = 1
// 创建表格
#table(
  columns: (1em, 10em, 1fr),
  stroke: (x: none, y: 0.2pt),
  align: (
    right + horizon, 
    left + horizon, 
    left + horizon),
  ..for (标题, 朝代, 作者, 内容) in data.古诗 {
    (
      [#i.],
      text(
        font: "SimHei",
        size: 10pt,
        标题) + h(1em) +
      text(
        font: "FangSong",
        size: 8pt,
        box([[#朝代] #作者])
      ),
      text(
        font: "FangSong",
        size: 8pt,
        内容
      )
    )
  i = i + 1
  }
)