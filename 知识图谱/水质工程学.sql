
-- 水质工程学
copy (from kg_nodes(
    course:='水质工程学',
    fname:='D:\misc\知识图谱\数据\水质工程学（含实践）.xlsx',
    sheet:='操作能力',
    data_range:='A2:N25',
    properties:={'能力': '操作'}))
to 'C:\Users\Think\Downloads\neo4j-community-2025.03.0\import\水质工程学_操作能力_知识点.csv'

copy (from kg_edges(
    course:='水质工程学',
    fname:='D:\misc\知识图谱\数据\水质工程学（含实践）.xlsx',
    sheet:='操作能力',
    data_range:='A2:N25'))
to 'C:\Users\Think\Downloads\neo4j-community-2025.03.0\import\水质工程学_操作能力_关系.csv'

-- 工业机器人
copy (from kg_nodes(
    fname:='C:\Users\Think\Downloads\水质工程学知识点.xlsx',
    sheet:='知识点设计样例',
    data_range:='A2:N181',
    root:='工业机器人'))
to 'C:\Users\Think\Downloads\neo4j-community-2025.03.0\import\工业机器人_知识点.csv'

copy (from kg_edges(
    fname:='C:\Users\Think\Downloads\水质工程学知识点.xlsx',
    sheet:='知识点设计样例',
    data_range:='A2:N181',
    root:='工业机器人'))
to 'C:\Users\Think\Downloads\neo4j-community-2025.03.0\import\工业机器人_关系.csv'


create or replace macro kg_nodes(
    course:='水质工程学',
    fname:='D:\misc\知识图谱\数据\水质工程学（含实践）.xlsx',
    specs:=[
        {'sheet': '操作能力',   'data_range': 'A2:N25'},
        {'sheet': '水质工程学', 'data_range': 'A2:N622'}]
    ) as table
select specs[1]['sheet']

from kg_nodes()
    
    
    
with xlsx as (
    select nullif(trim(columns(*)), '')
    from read_xlsx(fname, sheet:=sheet, range:=data_range, all_varchar:=true)),
node as (
    select list_any_value(kps) as 知识点,
        list_position(kps, list_any_value(kps)) as 层级,
        * not like '%知识点', course as 课程
    from (
        select list_value(*columns('.+级知识点')) as kps, *
        from xlsx)
    union by name
    select course as 知识点, 0 as 层级, course as 课程)
select distinct on (知识点) * exclude kps
from node cross join (select unnest(properties)) as p
where 知识点 is not null





-- macro definitions
create or replace macro kg_nodes(
    course:='水质工程学',
    fname:='D:\misc\知识图谱\数据\水质工程学（含实践）.xlsx',
    sheet:='操作能力',
    data_range:='A2:N25',
    properties:={'能力': '操作'}) as table
with xlsx as (
    select nullif(trim(columns(*)), '')
    from read_xlsx(fname, sheet:=sheet, range:=data_range, all_varchar:=true)),
node as (
    select list_any_value(kps) as 知识点,
        list_position(kps, list_any_value(kps)) as 层级,
        * not like '%知识点', course as 课程
    from (
        select list_value(*columns('.+级知识点')) as kps, *
        from xlsx)
    union by name
    select course as 知识点, 0 as 层级, course as 课程)
select distinct on (知识点) * exclude kps
from node cross join (select unnest(properties)) as p
where 知识点 is not null

create or replace macro kg_edges(
    course:='水质工程学',
    fname:='D:\misc\知识图谱\数据\水质工程学（含实践）.xlsx',
    sheet:='操作能力',
    data_range:='A2:N25') as table
with xlsx as (
    select nullif(trim(columns(*)), '')
    from read_xlsx(fname, sheet:=sheet, range:=data_range, all_varchar:=true)),
node as (
    select 
        row_number() over () as r, 
        list_position(kps, list_any_value(kps)) as c,
        list_any_value(kps) as 知识点,
        columns('(.+[^级])知识点') as '\1'
    from (
        select list_value(*columns('.+级知识点')) as kps, *
        from xlsx)
    union by name
    select 0 as r, 0 as c, course as 知识点),
tree as (
    select distinct on (ch.r) 
            columns(ch.* exclude (r,c)), pa.知识点 as 上级
    from node as ch inner join node as pa
        on ch.c = pa.c + 1
    where ch.r > pa.r
    order by ch.r, pa.r desc),
edge as (
    pivot_longer tree
    on columns(* exclude 知识点)
    into name 关系 value 知识点2)
select 知识点, 关系, trim(unnest(str_split(知识点2, ';'))) as 知识点2
from edge



