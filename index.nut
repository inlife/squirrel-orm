function require(filename) {
    // TODO: add second inclusion prevention
    return dofile(filename + ".nut", true);
}

require("json");

function dbg(data) {
    ::print("[debug] " + json.encode(data) + "\n");
}

const UNDEFINED = "UNDEFINED";
ORM <- {};

require("./Account");
require("./Query");

table_data <- {};
table_data["tbl_accounts"] <- [null, null, { id = 2,  username = "User", password = "123345" }];

database <- {};
database["select * from tbl_accounts where id = 2"] <- table_data["tbl_accounts"][2];

function simple_sql_query(query) {
    dbg("[running query] " + query);
    return database[query];
}

local result = ORM.Query("select * from @Account where id = :id")
    .setParameter("id", 2)
    .getResult();

dbg(result);
