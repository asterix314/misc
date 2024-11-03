// Imports
#import "@preview/brilliant-cv:2.0.3": cvSection, cvEntry
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("Projects")

#cvEntry(
  title: [Expert System for DevInsight],
  society: [Merico],
  date: [2019 - Present],
  location: [Beijing],
  description: list(
    [Created an expert system for software development diagnosis and evaluation, integrating FastAPI for web API interfacing and CLIPS for diagnostic rule matching.],
    [Derived expert rule parameters from statistical analysis of client historical data, enhancing the accuracy of development team performance evaluations.],
  ),
)

#cvEntry(
  title: [E-commerce Automatic Reporting],
  society: [BigoneLab],
  date: [2019 - Present],
  location: [Beijing],
  description: list(
    [Implemented algorithms for label aggregation, GMV estimation, and outlier detection, using a combination of textual analysis, Bayesian networks, and statistical techniques.],
    [Optimized storage parameters of Hive and Greenplum databases to handle large data volumes efficiently.],
  ),
)

#cvEntry(
  title: [MX.3 Platform Implementation for Industrial Bank of Taiwan],
  society: [Murex China],
  date: [Apr 2015 - Jan 2016],
  location: [Taipei],
  description: list(
    [Design and implementation of the bank's financial accounting module, covering fixed income, FX cash, derivatives and structured products, and meeting the regulatory requirement of IFRS9 compliance],
    [Established a set of general and efficient accounting schemes under close collaboration with the bank's accounting department],
    [On-site deployment and user training.],
  ),
)
