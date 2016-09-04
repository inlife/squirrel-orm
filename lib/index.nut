/**
 * Helper function for including
 * all needed files (look at dat filestructure tho!)
 */
function __orm_include(filename) {
    // TODO: add second inclusion prevention
    return dofile(filename + ".nut", true);
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
__orm_include("./lib/Field/Basic");
__orm_include("./lib/Field/Integer");
__orm_include("./lib/Field/Float");
__orm_include("./lib/Field/String");
__orm_include("./lib/Field/Text");
__orm_include("./lib/Field/Bool");
__orm_include("./lib/Field/Password");
__orm_include("./lib/Field/Timestamp");

__orm_include("./lib/Trait/Interface");
__orm_include("./lib/Trait/Positionable");

__orm_include("./lib/Utils/String");
__orm_include("./lib/Utils/Array");
__orm_include("./lib/Utils/GUID");

__orm_include("./lib/Driver");
__orm_include("./lib/Query");
__orm_include("./lib/Entity");

/**
 * Now, global namespace is populated
 * (polluted with this ORM shit :D )
 * and ready to work!
 */
