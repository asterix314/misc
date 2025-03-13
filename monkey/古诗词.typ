#set page(
  "a4",
  margin: (
    top: 5em,
    bottom: 2em, left: 4em, right: 4em,),
  flipped: true,
  columns: 2
)

#let data = toml("古诗词.toml")

#let i = 1
// 创建表格
#table(
  columns: (1em, 11em, 1fr),
  stroke: (x: none, y: 0.5pt),
  align: (
    right + horizon, 
    left + horizon, 
    left + horizon),
  ..for (标题, 朝代, 作者, 内容) in data.古诗 {
    (
      [#i.],
      text(
        font: "SimHei",
        size: 11pt,
        标题) + h(1em) +
      text(
        font: "FangSong",
        size: 10pt,
        box([[#朝代] #作者])
      ),
      text(
        font: "FangSong",
        size: 11pt,
        内容
      )
    )
  i = i + 1
  }
)