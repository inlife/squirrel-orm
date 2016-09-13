dofile("index.nut", true);

/**
 * Glorious testing suite
 */
__passed <- 0;
__total  <- 0;

function is(condition, exp) {
    try {
        assert(exp); __passed++;
        ::print("  \x1B[32m[✓]\x1B[0m is " + condition + " - passed\n");
    } catch (e) {
        ::print("  \x1B[31m[✗]\x1B[0m is " + condition + " - failed\n");
    }
    return __total++;
}

function describe(text, data) {
    ::print("\n"+ text + ":\n");
    data();
}

::print("Starting test for squirrel-orm:\n");

/**
 * Actual test cases
 */
describe("Testing defines", function() {
    is("ORM.Query defined", ORM.Query);
    is("ORM.Entity defined", ORM.Entity);
    is("ORM.Field.Basic defined", ORM.Field.Basic);
});

describe("Testing Driver", function() {
    ORM.Driver.configure({
        provider = "sqlite"
    });

    is("Driver able to switch provider", ORM.Driver.storage.provider == "sqlite");

    ORM.Driver.setProxy(function(query, cb) {
        cb(null, true);
    });

    ORM.Driver.query("", function(err, result) {
        is("Driver able to response to proxy", result);
    });
})

describe("Testing Query", function() {

    local q = ORM.Query("select * from table").compile();
    is("Query compile plain expressions", q == "select * from table");

    local q = ORM.Query("select * from table where a = :param").setParameter("param", 2).compile();
    is("Query compile expressions with parameters", q == "select * from table where a = 2");

    local q = ORM.Query("select * from table where a = :param").setParameter("param", "somestr").compile();
    is("Query able to escape string parameter", q == "select * from table where a = 'somestr'");

    class TestingOne extends ORM.Entity {
        static classname = "Testing";
        static table = "tbl_tst";
    }

    local q = ORM.Query("select * from @TestingOne").compile();
    is("Query compile expressions with entity names", q == "select * from tbl_tst");

    ORM.Driver.setProxy(function(query, cb) {
        return cb(null, [{single = true}, {multiple = true}]);
    });

    ORM.Query("select * from tbl").getSingleResult(function(err, obj) {
        is("Query returns single result after query", obj.single == true);
    });

    ORM.Query("select * from tbl").getResult(function(err, obj) {
        is("Query returns multiple results after query", (obj.len() == 2) && (obj[1].multiple == true));
    });

    class TestingTwo extends ORM.Entity {
        static classname = "TestingTwo";
        static table = "tbl";
        static fields = [ ORM.Field.Integer({ name = "other", value = 1 }) ];
    }

    ORM.Driver.setProxy(function(q, cb) {
        cb(null, [
            { _uid = 1, _entity = "TestingTwo", other = 124 }
        ]);
    });

    ORM.Query("select * from tbl").getSingleResult(function(err, results) {
        is("Query able to build entity object from plain data", 
            (results instanceof TestingTwo) &&
            (results instanceof ORM.Entity) &&
            (results.get("_uid") == 1) &&
            (results.get("other") == 124)
        )
    });
});

describe("Testing ORM.Fields", function() {

});

/**
 * Results
 */
::print(format("\nTotal passed %d/%d, total failed %d.\n", __passed, __total, __total - __passed));
