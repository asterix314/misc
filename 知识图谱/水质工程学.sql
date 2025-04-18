-- convert Excel to CSV for import to neo4j

-- 水质工程学
copy (from kg_nodes(
    fname:='C:\Users\Think\Downloads\水质工程学知识点.xlsx',
    sheet:='水质工程学1知识点设计',
    data_range:='B2:N42',
    root:='水质工程学'))
to 'C:\Users\Think\Downloads\neo4j-community-2025.03.0\import\水质工程学_知识点.csv'

copy (from kg_edges(
    fname:='C:\Users\Think\Downloads\水质工程学知识点.xlsx',
    sheet:='水质工程学1知识点设计',
    data_range:='B2:N42',
    root:='水质工程学'))
to 'C:\Users\Think\Downloads\neo4j-community-2025.03.0\import\水质工程学_关系.csv'

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



--  then in neo4j
match (n:知识点) detach delete n;

load csv with headers from 'file:///水质工程学_知识点.csv' as properties
call apoc.create.node(['知识点'], properties) yield node
return node as 知识点;

load csv with headers from 'file:///水质工程学_关系.csv' as rel
match (a:知识点{知识点: rel.知识点})
match (b:知识点{知识点: rel.知识点2})
merge (a)-[:$(rel.关系)]->(b);

load csv with headers from 'file:///工业机器人_知识点.csv' as properties
call apoc.create.node(['知识点'], properties) yield node
return node as 知识点;

load csv with headers from 'file:///工业机器人_关系.csv' as rel
match (a:知识点{知识点: rel.知识点})
match (b:知识点{知识点: rel.知识点2})
merge (a)-[:$(rel.关系)]->(b);



-- macro definitions

create or replace macro kg_nodes(
    fname:='C:\Users\Think\Downloads\水质工程学知识点.xlsx',
    sheet:='水质工程学1知识点设计',
    data_range:='B2:N42',
    root:='水质工程学') as table
with xlsx as (
    select nullif(trim(columns(*)), '')
    from read_xlsx(fname, sheet:=sheet, range:=data_range, all_varchar:=true)),
node as (
    select coalesce(*columns('.级知识点')) as 知识点, * not like '%知识点', root as 课程
    from xlsx
    union by name
    select root as 知识点, root as 课程)
select distinct on (知识点) *
from node
order by 知识点

create or replace macro kg_edges(
    fname:='C:\Users\Think\Downloads\水质工程学知识点.xlsx',
    sheet:='水质工程学1知识点设计',
    data_range:='B2:N42',
    root:='水质工程学') as table
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
    select 0 as r, 0 as c, root as 知识点),
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





-- scratchpad

-- 工业机器人
--with xlsx as (
--    select nullif(trim(columns(*)), '')
--    from read_xlsx(
--        "C:\Users\Think\Downloads\9-2：水质工程学-1（双语）-知识图谱知识点梳理表-给李夕耀.xlsx",
--        sheet='知识点设计样例',
--        range='A12:N191',
--        all_varchar = true)),
--node as (
--    from (
--        select 
--            generate_subscripts(items, 1) AS c, 
--            unnest(items) as 知识点, 
--            * not like 'items' 
--        from (
--            select 
--                row_number() over () as r, 
--                list_value(*columns('.级知识点')) as items, 
--                * not like '_级知识点'
--            from xlsx))
--    where 知识点 is not null
--    union by name
--    select 0 as c, 0 as r, '工业机器人' as 知识点
--    ),    
--node_cypher as (
--    select regexp_replace(format('(:知识点 {})',
--        to_json(struct_pack(
--            课程:='工业机器人',
--            name:=知识点, 
--            标签:=string_split(coalesce(标签, ''), ';'), 
--            认知维度:=coalesce(认知维度, ''), 
--            分类:=coalesce(分类, ''), 
--            教学目标:=coalesce(教学目标, '')))),
--            '"([^"]+)":', '\1:', 'g') as cypher
--    from node),
--tree as (
--    select distinct on (ch.r) 
--        ch.知识点, pa.知识点 as 知识点2, '上级' as edge_type
--    from node as pa inner join node as ch
--        on pa.c + 1 = ch.c
--    where ch.r > pa.r
--    order by ch.r, pa.r desc),    
--edge as (
--    select 知识点, trim(unnest(string_split(关联知识点, ';'))) as 知识点2, '关联' as edge_type
--    from node
--    union all
--    select 知识点, trim(unnest(string_split(前置知识点, ';'))) as 知识点2, '前置' as edge_type
--    from node
--    union all
--    select 知识点, trim(unnest(string_split(后置知识点, ';'))) as 知识点2, '后置' as edge_type
--    from node
--    union all
--    select 知识点, 知识点2, edge_type
--    from tree),
--edge_cypher as (
--    select format(
--        'MATCH (n1:知识点 {{课程: ''工业机器人'', name: ''{0}''}}), (n2:知识点 {{课程: ''工业机器人'', name: ''{1}''}}) CREATE (n1) -[:{2}]-> (n2);',
--        知识点, 知识点2, edge_type) as cypher
--    from edge)
--select 'CREATE
--' || string_agg(cypher, ',
--')
--from node_cypher
--union all
--select string_agg(cypher, '
--')
--from edge_cypher    
--    
    
    

