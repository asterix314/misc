#import "@preview/i-figured:0.2.4"
#import "@preview/hydra:0.5.1": hydra

#let title = [数据治理产品操作规范]

#let menu(..items) = {
  let path = items
    .pos()
    .join(h(.4em) + box(baseline: -2pt, [▶]) + h(.4em))
  set text(font: "FangSong")
  [「] + [#path] + [」]
}

#let template(body) = {
  
  show raw: set text(font: ("Fira Code", "FangSong"))
  show strong: it => text(font: "SimHei", it.body)
  show footnote.entry: set text(font: "FangSong")
  show outline.entry: set text(14pt, font: "FangSong")
  show figure.caption: set text(font: "FangSong")
  show heading: i-figured.reset-counters
  show figure: i-figured.show-figure
  show heading: set block(spacing: 1.2em)
  show figure: set block(spacing: 2em)

  show table.cell.where(y: 0): strong
  show table: set text(font: "FangSong")

  set table(
    stroke: 0.5pt + gray,
    fill: (x, y) =>
      if y == 0 {
        gray.lighten(60%)
      },
    align: (x, y) =>
      if y == 0 {bottom + center} 
      else if x == 0 {right + horizon}
      else {left}
  )

  set heading(numbering: "1.1") 
  set figure(placement: none)
  
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    align(center)[
    #text(16pt, font: "SimHei")[#it]
    ]
  }

  set text(
    font: ("Times New Roman", "SimSun"), 
    size: 12pt,
    lang: "zh"
  )

  set page(
    header: context{
      text(
        size: 12pt, 
        font: "FangSong", 
        baseline: 8pt,
        hydra(1) + h(1fr) + title)
      line(length: 100%)}
  )

  set par(justify: true)

  // 段落首行缩进 hack
  show: body => {
    for (ie, elem) in body.children.enumerate() {
      if elem.func() == text or elem.func() == strong {
        if ie > 0 and body.children.at(ie - 1).func() == parbreak {
          h(2em)
        }
        elem
      } else {
        elem
      }
    }
  }

  body
}
