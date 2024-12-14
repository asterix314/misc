-- chmod +x ./duck.db
-- ./duck.db << EOF

load './mysql_scanner.duckdb_extension';

create secret (
    type mysql,
    host '10.201.132.224',
    port 9030,
    user 'datakits_prod',
    password 'cisdi@123456'
);

attach 'database=ods_prod' as ods_prod (type mysql);
attach 'database=dw_prod' as dw_prod (type mysql);

with recursive tree(node_id, node_name, parent_id, path_id, path_name) as (
    select nodeid, nodename, null::text, [nodeid], [nodename]
    from ods_prod.ODS_HR_GBRS_TREENODE
    where nodeid = 'A799F1BF-A759-AF95-C187-698530576CF9'
    union all
    select c.nodeid, c.nodename, c.parentid, 
        list_append(p.path_id, c.nodeid),
        list_append(p.path_name, c.nodename)
    from ods_prod.ODS_HR_GBRS_TREENODE as c 
        inner join tree as p on c.parentid = p.node_id)
insert into dw_prod.DWS_HR_CADRE_TREE_NODE by name
from tree;

-- EOF