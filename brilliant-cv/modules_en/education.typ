// Imports
#import "@preview/brilliant-cv:2.0.3": cvSection, cvEntry, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("Education")

#cvEntry(
  title: [Master of Computer Science],
  society: [Tsinghua University],
  date: [2007 - 2011],
  location: [Beijing & Shenzhen],
  logo: image("../src/logos/清华大学-logo.svg"),
  description: list(
    // [Thesis: Predicting Customer Churn in Telecommunications Industry using Machine Learning Algorithms and Network Analysis],
    // [Course: Computer Architecture #hBar() Analysis of Algorithms #hBar() Database Systems #hBar() Network Security],
  ),
)

#cvEntry(
  title: [Bachelor of Applied Physics],
  society: [Tsinghua University],
  date: [1999 - 2003],
  location: [Beijing],
  logo: image("../src/logos/清华大学-logo.svg"),
  description: list(
    // [Thesis: Exploring the Use of Machine Learning Algorithms for Predicting Stock Prices: A Comparative Study of Regression and Time-Series Models],
    // [Course: Database Systems #hBar() Computer Networks #hBar() Software Engineering #hBar() Artificial Intelligence],
  ),
)