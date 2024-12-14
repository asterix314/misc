#set page(
  "a4",
  flipped: true,
  columns: 2
)

#let data = toml("古诗词.toml")

// 创建表格
#let table = table(
    headers: ["标题", "朝代", "作者", "内容"],
    rows: [
        for item in data["古诗文"] {
            [item["标题"], item["朝代"], item["作者"], item["内容"]]
        }
    ]
)

// 输出表格
table