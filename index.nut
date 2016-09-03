/**
 * PROD LIB CODE
 */
function require(filename) {
    // TODO: add second inclusion prevention
    return dofile(filename + ".nut", true);
}

function _uid(length = 8) {
    local symbols = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";
    local string = "";

    if (first > 0) {
        srand((rand() & time()) * clock());
        first--;
    }

    for (local i = 0; i < length; i++) {
        local pos = rand() % symbols.len();
        string += symbols.slice(pos, pos + 1);
    }

    return string;
}

const UNDEFINED = "UNDEFINED";

ORM <- {
    Trait = {}
};

/**
 * PROD USE CODE
 */

require("./Driver");

ORM.Driver.setProxy(function(query, cb) {
    cb(null, [simple_sql_query(query)]);
});

/**
 * TESTING CODE
 */

require("json");

function dbg(data) {
    ::print("[debug] " + json.encode(data) + "\n");
}

require("./Account");
require("./Query");

table_data <- {};
table_data["tbl_accounts"] <- [null, null, { _uid = 2, _entity = "Account",  username = "User", password = "123345" }];

database <- {};
database["select * from tbl_accounts where id = 2"] <- table_data["tbl_accounts"][2];
database["select username from tbl_accounts where id = 2"] <- table_data["tbl_accounts"][2].username;

function simple_sql_query(query) {
    dbg("[running query] " + query);
    return database[query];
}

function run_external_db_request(query, callback) {
    
}

// type 1 (almost plain query)
ORM.Query("select username from @Account where id = :id")
    .setParameter("id", 2)
    .getSingleResult(function(err, result) {
        dbg(result);
    });

// Account.findAll();

// type 2 (entity manager/repository)
// local result = Account:findOneBy({ id = 2 });
// local acc = Account({ username = "test", password = "123123" }).save(function(err, result) {
// });

// for (local i = 0; i < 50; i++) {
//     dbg(_uid());
// }

