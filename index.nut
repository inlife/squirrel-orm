/**
 * PROD CODE
 */
function require(filename) {
    // TODO: add second inclusion prevention
    return dofile(filename + ".nut", true);
}

function _uid(length = 8) {
    local symbols = "abcdefghijklmopqrstuvwxyz0123456789";

}

const UNDEFINED = "UNDEFINED";

ORM <- {
    Trait = {}
};

/**
 * TESTING CODE
 */

// ORM.Driver({

// });

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

function simple_sql_query(query) {
    dbg("[running query] " + query);
    return database[query];
}

function run_external_db_request(query, callback) {
    callback(null, [simple_sql_query(query)]);
}

// type 1 (almost plain query)
ORM.Query("select * from @Account where id = :id")
    .setParameter("id", 2)
    .getSingleResult(function(err, result) {
        dbg(result);
    });

// Account.findAll();

// type 2 (entity manager/repository)
// local result = Account:findOneBy({ id = 2 });
// local acc = Account({ username = "test", password = "123123" }).save(function(err, result) {
// });

function randomBytes() {
    return time();
}

function randomByte() {
    return randomBytes(1)[0] & 0x30;
}

function encode(lookup, number) {
    local loopCounter = 0;
    local done;

    local str = "";

    while (!done) {
        str = str + lookup( ( (number >> (4 * loopCounter)) & 0x0f ) | randomByte() );
        done = number < (pow(16, loopCounter + 1 ) );
        loopCounter++;
    }
    return str;
}


function lookup(index) {
    local alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";
    return alphabet[index];
}

// Ignore all milliseconds before a certain time to reduce the size of the date entropy without sacrificing uniqueness.
// This number should be updated every year or so to keep the generated id short.
// To regenerate `new Date() - 0` and bump the version. Always bump the version!
local REDUCE_TIME = 1459707606518;

// don't change unless we change the algos or REDUCE_TIME
// must be an integer and less than 16
local version = 6;

// if you are using cluster or multiple servers use this to make each instance
// has a unique value for worker
// Note: I don't know if this is automatically set when using third
// party cluster solutions such as pm2.
local clusterWorkerId = 0;

// Counter is used when shortid is called multiple times in one second.
local counter;

// Remember the last time shortid was called in case counter is needed.
local previousSeconds;

function generate() {

    local str = "";

    local seconds = floor((time() - REDUCE_TIME) * 0.001);

    if (seconds == previousSeconds) {
        counter++;
    } else {
        counter = 0;
        previousSeconds = seconds;
    }

    str = str + encode(lookup, version);
    str = str + encode(lookup, clusterWorkerId);
    if (counter > 0) {
        str = str + encode(lookup, counter);
    }
    str = str + encode(lookup, seconds);

    return str;
}

dbg(randomBytes());
