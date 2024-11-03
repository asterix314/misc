// Imports
#import "@preview/brilliant-cv:2.0.3": cvSection, cvSkill, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)


#cvSection("Core Competencies")

#cvSkill(
  type: [Data Capability],
  info: [Proficient in SQL and Python, with experience in building and maintaining data systems for analytics and evaluation.],
)

#cvSkill(
  type: [Project Management],
  info: [Successful in creating and managing over 10 data analysis projects, including automated ETL processes and graphical monitoring.],
)

#cvSkill(
  type: [Business Sense],
  info: [Demonstrated ability to translate data insights into actionable business strategies, fostering dialogue and discussion with business units.],
)

#cvSkill(
  type: [Presentation],
  info: [Skilled in packaging data insights into compelling presentations and collateral, using tools like PowerPoint to engage and persuade business stakeholders.],
)

#cvSkill(
  type: [Tech Stack],
  info: [Database/SQL #hBar() Python (Polars / Numpy) #hBar() ETL #hBar() BI #hBar() Wolfram Language],
)

#cvSkill(
  type: [Language],
  info: [Chinese (native) #hBar() English (fluent)],
)
