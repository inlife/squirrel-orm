function __tinclude(filename) {
    // TODO: add second inclusion prevention
    return dofile(filename + ".nut", true);
}

__tinclude("./test/json");

function dbg(data) {
    ::print("[debug] " + json.encode(data) + "\n");
}


// load lib
__tinclude("./lib/index");

// set up driver
ORM.Driver.setProxy(function(query, cb) {
    cb(null, [simple_sql_query(query)]);
});

__tinclude("./test/Account");

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
ORM.Query("select * from @Account where id = :id")
    .setParameter("id", 2)
    .getSingleResult(function(err, result) {
        dbg(result.username);
    });

dbg(Account().__create().compile());

// Account.findAll();

// type 2 (entity manager/repository)
// local result = Account:findOneBy({ id = 2 });
// local acc = Account({ username = "test", password = "123123" }).save(function(err, result) {
// });

// for (local i = 0; i < 50; i++) {
//     dbg(_uid());
// }

