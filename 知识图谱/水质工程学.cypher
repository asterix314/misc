match (n:水质工程学知识点) detach delete n;

load csv with headers from 'file:///水质工程学_操作能力_知识点.csv' as properties
call apoc.create.node(['水质工程学知识点'], properties) yield node
return node as 知识点;

load csv with headers from 'file:///水质工程学_操作能力_关系.csv' as rel
match (a:水质工程学知识点{知识点: rel.知识点})
match (b:水质工程学知识点{知识点: rel.知识点2})
merge (a)-[:$(rel.关系)]->(b);
