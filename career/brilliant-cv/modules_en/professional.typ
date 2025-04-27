// Imports
#import "@preview/brilliant-cv:2.0.5": cvSection, cvEntry
#let metadata = toml("../metadata_en.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("Professional Experience")

#cvEntry(
  title: [Data Scientist],
  society: [Merico DevInsight],
  logo: image("../src/logos/merico-logo.png"),
  date: [Dec 2021 - Jun 2023],
  location: [Beijing],
  description: list(
    [Developed and maintained an expert system back-end for evaluating development team performance, utilizing Python and Langchain.],
    [Built a data analysis platform from scratch, conducting data modeling and producing industry benchmark reports.],
    [Collaborated with sales team to learn the most needed indicators from data, and presenting the data team's findings.]
  ),
  tags: ("Expert System", "LLM", "PostgreSQL", "Python", "Benchmarking"),
)

#cvEntry(
  title: [Data Analysis Team Lead],
  society: [BigoneLab],
  logo: image("../src/logos/bigonelab-logo.png"),
  date: [Apr 2018 - Jul 2021],
  location: [Beijing],
  description: list(
    [Led the creation and maintenance of data analysis projects for e-commerce and streaming video platforms on a tight schedule, focusing on automated calculation and graphical monitoring.],
    [Introduced cost-effective data infrastructure solutions like Hive on Hadoop and Apache MADlib, managing smooth data migrations.],
    [Managed data analysis teams, ensuring efficient workflow and data security through role-based access controls.]
  ),
  tags: ("Greenplum", "MADlib", "metabase", "ETL"),
)

#cvEntry(
  title: [IT Specialist (VP)],
  society: [China Securities],
  logo: image("../src/logos/中信建投-logo.png"),
  date: [Jul 2016 - Apr 2018],
  location: [Beijing],
  description: list(
    [Designed and developed an in-house accounting system for brokerage business, creating a data platform for user profiling and risk analysis.],
    [Implemented an Anti-Money Laundering expert system, enhancing the company's compliance capabilities.]),
  tags: ("Accounting", "SQLServer", "EOD"),
)

#cvEntry(
  title: [Senior Consultant],
  society: [Murex China],
  logo: image("../src/logos/murex-logo.svg"),
  date: [Jul 2011 - Jul 2016],
  location: [Beijing],
  description: list(
    [Provided consultation on trade validation, confirmation, and settlement within the MX platform, supporting several banks' capital market business.],
    [Overhauled and updated the accounting subsystem, ensuring compliance with IFRS9 and other financial accounting standards, while working closely with the bank's accounting staff.]),
  tags: ("MX.3", "IFRS", "Presale", "Business Travels", "POC", "UAT"),
)
