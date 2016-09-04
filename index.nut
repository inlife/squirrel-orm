/**
 * PROD LIB CODE
 */

/**
 * Helper function for including
 * all needed files (look at dat filestructure tho!)
 */
function __include(filename) {
    // TODO: add second inclusion prevention
    return dofile(filename + ".nut", true);
}

__include("json");

function dbg(data) {
    ::print("[debug] " + json.encode(data) + "\n");
}

/**
 * Undefined constant
 * used all over the code
 * @type {String}
 */
const UNDEFINED = "UNDEFINED";

/**
 * Defining our
 * glorious namespace
 */
ORM <- {
    Trait = {}
    Field = {}
    Utils = {}
};

/**
 * Marvelous includes
 * First of all fields
 * then traits
 * then utils
 * and then all the main stuff
 */
__include("./Field/Basic");
__include("./Field/Integer");
__include("./Field/Float");
__include("./Field/String");
__include("./Field/Text");
__include("./Field/Bool");
__include("./Field/Password");
__include("./Field/Timestamp");

__include("./Trait/Interface");
__include("./Trait/Positionable");

__include("./Utils/String");
__include("./Utils/GUID");

__include("./Driver");
__include("./Query");
__include("./Entity");

/**
 * PROD USE CODE
 */

ORM.Driver.setProxy(function(query, cb) {
    cb(null, [simple_sql_query(query)]);
});

/**
 * TESTING CODE
 */

__include("./Account");

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

