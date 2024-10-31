# coding: utf-8

import datetime

from JudicialBigData import JudicialBigData


jbd = JudicialBigData("司法大数据配置.json")

if datetime.date.today().weekday() in (5, 6): # 周末全量
    jbd.import_cases(incremental=False)
else:
    jbd.import_cases(incremental=True)        # 工作日增量

