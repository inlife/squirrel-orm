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
 * Basic class for field
 * Must be inherited to be used
 */
class ORM.Field.Basic {

    /**
     * Name of field
     * @type {String}
     */
    __name = UNDEFINED;

    /**
     * Default value
     * @type {Mixed}
     */
    __value = null;

    /**
     * Is field a primary key
     * @type {Boolean}
     */
    __primary = false;

    /**
     * Is this field is auto incremented
     */
    __autoinc = false;

    /**
     * Is field nullable
     * @type {Boolean}
     */
    __nullable = false;

    /**
     * Is this field will be exported on Entity.export
     * @type {Boolean}
     */
    __exported = true;

    /**
     * Field type
     * @type {String}
     */
    static type = UNDEFINED;

    /**
     * Field size (yea, some fields have 'em)
     * @type {Number}
     */
    static size = 0;

    /**
     * Field size (yea, some fields have 'em)
     * @type {Number}
     */
    static value = UNDEFINED;

    /**
     * Constructor that populates data
     * from provided data table
     * @param  {Object} data
     */
    constructor (data) {
        // try to parse 1 argument as name
        if (typeof(data) == "string") {
            data = { "name": data };
        }

        // check most important parameter - name
        if (!("name" in data) || data.name.tostring().len() < 1) {
            throw "ORM.Field: you haven't provided valid name for a field " + typeof(this);
        }

        if (this.type == UNDEFINED) {
            throw "ORM.Field: you haven't inherited base field, or did not set it's database type for: " + data.name;
        }

        // convert to lower and save
        this.__name = data.name.tostring().tolower();

        // check and save others
        this.__primary  = "primary"  in data ? data.primary  : false;
        this.__nullable = "nullable" in data ? data.nullable : false;
        this.__autoinc  = "autoinc"  in data ? data.autoinc  : false;
        this.__exported = "exported" in data ? data.exported : true;

        // handle the default value
        if ("value" in data) {
            this.__value = data.value;
        } else if (this.value != UNDEFINED) {
            this.__value = this.value;
        }
    }

    /**
     * Create field descriptor for db
     * @return {string}
     */
    function __create() {
        // get field type
        local type = this.type.toupper();

        // attach size if not 0
        if (this.size != 0) {
            type += "(" + this.size + ")";
        }

        // metadata
        local nullable  = this.__nullable ? "NULL" : "NOT NULL";
        local autoinc   = this.__autoinc ? "AUTO_INCREMENT" : "";
        local primary   = this.__primary ? "PRIMARY KEY" : "";

        // default value
        local defval = this.__value && this.__name != "_entity" ? "DEFAULT " + this.__value : "";

        // insert and return;
        return strip(format("`%s` %s %s %s %s %s",
            this.getName(), type, nullable, autoinc, primary, defval
        ));
    }

    /**
     * Helper method to accessing field name
     * lowercases the name, and throws error if not redefined
     * @return {String} [description]
     */
    function getName() {
        if (this.__name == UNDEFINED) {
            throw "ORM.Field: you haven't provided valid name for a field " + typeof(this);
        }

        return this.__name.tolower();
    }
    
    /**
     * Method that encodes value
     * according to field class
     * @param  {Mixed} currentValue
     * @return {Mixed}
     */
    function encode(currentValue) {
        return currentValue;
    }

    
    /**
     * Method that decodes value
     * according to field class
     * @param  {Mixed} encodedValue
     * @return {Mixed}
     */
    function decode(encodedValue) {
        return encodedValue;
    }
}
class ORM.Field.Integer extends ORM.Field.Basic {
    static type = "int";
    static value = 0;
    static size = 255;

    /**
     * Method that encodes value
     * according to field class
     * @param  {Mixed} currentValue
     * @return {Mixed}
     */
    function encode(currentValue) {
        return currentValue.tointeger();
    }

    /**
     * Method that decodes value
     * according to field class
     * @param  {Mixed} encodedValue
     * @return {Mixed}
     */
    function decode(encodedValue) {
        return encodedValue.tointeger();
    }
}
class ORM.Field.Float extends ORM.Field.Basic {
    static type = "float";
    static value = 0.0;

    /**
     * Method that encodes value
     * according to field class
     * @param  {Mixed} currentValue
     * @return {Mixed}
     */
    function encode(currentValue) {
        return currentValue.tofloat();
    }

    /**
     * Method that decodes value
     * according to field class
     * @param  {Mixed} encodedValue
     * @return {Mixed}
     */
    function decode(encodedValue) {
        return encodedValue.tofloat();
    }
}
class ORM.Field.String extends ORM.Field.Basic {
    static type = "varchar";
    static size = 255;
    static value = "";
    
    /**
     * Method that encodes value
     * according to field class
     * @param  {Mixed} currentValue
     * @return {Mixed}
     */
    function encode(currentValue) {
        return format("'%s'", currentValue.tostring());
    }

    /**
     * Method that decodes value
     * according to field class
     * @param  {Mixed} encodedValue
     * @return {Mixed}
     */
    function decode(encodedValue) {
        return encodedValue.tostring();
    }
}
class ORM.Field.Text extends ORM.Field.String {
    static type = "text";
}
class ORM.Field.Bool extends ORM.Field.Basic {
    static type = "tinyint";
    static size = 1;

    /**
     * Method that encodes value
     * according to field class
     * @param  {Mixed} currentValue
     * @return {Mixed}
     */
    function encode(currentValue) {
        return currentValue.tointeger();
    }

    /**
     * Method that decodes value
     * according to field class
     * @param  {Mixed} encodedValue
     * @return {Mixed}
     */
    function decode(encodedValue) {
        return encodedValue.tointeger() == 1;
    }
}
class ORM.Field.Id extends ORM.Field.Integer {
    __primary = true;
    __autoinc = true;
}
// TODO: make hasahble password
class ORM.Field.Password extends ORM.Field.String {}
class ORM.Field.Timestamp extends ORM.Field.Basic {
    static type = "timestamp";
    static value = "CURRENT_TIMESTAMP()";
}
class ORM.Trait.Interface {}
class ORM.Trait.Positionable extends ORM.Trait.Interface {

    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        ORM.Field.Float({ name = "x" }),
        ORM.Field.Float({ name = "y" }),
        ORM.Field.Float({ name = "z" })
    ];

    /**
     * Methods that will be inserted into traited model, kinda
     */
    function setPosition() {

    }

    function getPosition() {
        
    }
}
class ORM.Utils.String {
    
    /**
     * Replace occurances of "search" to "replace" in the "subject"
     * @param  {string} search
     * @param  {string} replace
     * @param  {string} subject
     * @return {string}
     */
    function replace(original, replacement, string) {
        local expression = regexp(original);
        local result = "";
        local position = 0;
        local captures = expression.capture(string);

        while (captures != null) {
            foreach (i, capture in captures) {
                result += string.slice(position, capture.begin);
                result += replacement;
                position = capture.end;
            }

            captures = expression.capture(string, position);
        }

        result += string.slice(position);

        return result;
    }

}
class ORM.Utils.Array {
    /**
     * Join array using sep as separator
     * Author: @Stormeus
     * http://forum.vc-mp.org/?topic=3226.0
     * 
     * @param  {Array} arr
     * @param  {String} sep
     * @return {String}
     */
    static function join(arr, sep) {
        if (typeof(arr) != "array") {
            throw "join_array expected array input, got " + typeof(arr) + " (" + arr + ")";
        } else if (typeof(sep) != "string") {
            throw "join_array expected string separator, got " + typeof(sep) + " (" + sep + ")";
        } else if (arr.len() <= 0) {
            return "";
        }

        return arr.reduce(@(a, b) a + sep + b);
    }
}
ORM.Utils["GUID"] <- function (length = 8) {
    // TODO: add shuffle
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
class ORM.Utils.Formatter {
    /**
     * Method calculates changes for the entity
     * and transofrms them into a string for a query
     * @param  {ORM.Entity} entity
     * @return {String}
     */
    static function calculateUpdates(entity) {
        local result = [];

        foreach (idx, name in entity.__modified) {
            local field = entity.__fields[name];
            local value = entity.__data[name];

            result.push(format("`%s` = %s", field.getName(), field.encode(value)));
        }

        return ORM.Utils.Array.join(result, ",");
    }

    /**
     * Method calculates field names for insertion of the entity
     * and transofrms them into a string for a query
     * @param  {ORM.Entity} entity
     * @return {String}
     */
    static function calculateFields(entity) {
        local result = [];

        foreach (name, field in entity.__fields) {
            if (field instanceof ORM.Field.Id) continue;
            result.push(format("`%s`", field.getName()));
        }

        return ORM.Utils.Array.join(result, ",");
    }

    /**
     * Method calculates field values for insertion of the entity
     * and transofrms them into a string for a query
     * @param  {ORM.Entity} entity
     * @return {String}
     */
    static function calculateValues(entity) {
        local result = [];

        foreach (name, field in entity.__fields) {
            if (field instanceof ORM.Field.Id) continue;
            result.push(field.encode(entity.__data[name]));
        }

        return ORM.Utils.Array.join(result, ",");
    }

    static function escape(value) {
        return (typeof(value) == "string" ? "'" + value + "'" : value).tostring();
    }

    /**
     * Method calculates condition for the entity
     * and transofrms them into a string for a query
     * @param  {ORM.Entity} entity
     * @return {String}
     */
    static function calculateCondition(condition) {
        if (typeof(condition) == "string") {
            return "WHERE " + condition;
        }

        if (typeof(condition) != "table") {
            throw "ORM.Query: you have to provide table or a string as a condition to a query";
        } 

        // skip if empty
        if (condition.len() < 1) {
            return "";
        }

        local result = [];

        foreach (name, value in condition) {
            result.push(format("`%s` = %s", name, this.escape(value)));
        }

        return "WHERE " + ORM.Utils.Array.join(result, " AND ");
    }
}
class ORM.Driver {
    static storage = {
        proxy = null,
        configured = false
    };

    constructor () {
        
    }

    function configure() {

    }

    function setProxy(callback) {
        storage.proxy = callback;
        storage.configured = true;
    }

    function query(queryString, callback) {
        if (!storage.configured) throw "ORM.Driver: you didn't configure the driver";
        storage.proxy(queryString, callback);
    }
}
/**
 * Class for creating and executing(proxying to a driver) SQL queries
 * Examples:
 *     Query("select * from @MyEntity").getResult()
 *     Query("select p.id, d.size from tbl_p p left join tbl_d d on d.id = p.size_id where p.id = :id").setParameter('id', 15).getSingleResult()
 *     Query("delete from @MyEntity").execute()
 */
class ORM.Query {

    /**
     * Field stores current raw query
     * @type {string}
     */
    __raw = null;

    /**
     * Fild stores current compiled query
     * @type {[type]}
     */
    __compiled = null;

    /**
     * Field with table of predefined
     * regex expressions for matching in parse method
     * @type {Object}
     */
    __regex = {
        entityName = regexp("@[A-Za-z_]+"),
        parameters = regexp(":[A-Za-z_]+")
    };

    /**
     * Field storage for matched data after parse method
     * (storing named entities and parameters)
     * @type {Object}
     */
    __matched = null;

    constructor (queryString) {
        // fill in default data
        this.__matched = {
            entities = {},
            parameters = {}
        };

        // save plain raw query string
        this.__raw = queryString;

        // start parsing, and
        // throw errors if any found
        this.__parse(queryString);
    }

    /**
     * Method tries to parse raw query
     * throws error if entities, matched in query was not found in global namespace
     * @param  {string} queryString
     */
    function __parse(queryString) {
        // search for entity names in query
        local previousPosition = 0;
        while (true) {
            local results = this.__regex.entityName.search(
                queryString, previousPosition
            );

            if (!results) break;

            // extract entity name
            local entityName = queryString.slice(results.begin + 1, results.end);

            try {
                // extract entity class by name
                local entityClass = compilestring("return " + entityName + ";")();

                // save it to local storage
                this.__matched.entities[entityName] <- entityClass;
            } catch (e) {
                throw "ORM.Query: tried to access to non-declared entity: " + entityName
                     + "\n in query: " + this.__raw;
            }

            previousPosition = results.end;
        }

        // search for params in query
        previousPosition = 0;
        while (true) {
            local results = this.__regex.parameters.search(
                queryString, previousPosition
            );

            if (!results) break;

            // extract parameter name
            local paramName = queryString.slice(results.begin + 1, results.end);

            // save it to local storage
            this.__matched.parameters[paramName] <- UNDEFINED;

            previousPosition = results.end;
        }
    }

    /**
     * Sets a value binded to parameter name
     * throws error if parameter was not created
     * @param {string} name
     * @param {mixed} value
     */
    function setParameter(name, value) {
        // TODO: add validation and escaping to "value"

        try {
            this.__matched.parameters[name] = value;
        } catch (e) {
            throw "ORM.Query: tried to populate unregistered parameter: " + name
                 + "\n in query: " + this.__raw;
        }

        return this;
    }

    /**
     * Compile raw query into baked query
     * (ready to be sent to dbms)
     * @param {bool} recomplie force recompilation
     * @return {string}
     */
    function compile(recompile = false) {
        // return exsting if no forced recompilation
        if (!recompile && this.__compiled != null) {
            return this.__compiled;
        }

        local query = this.__raw;

        // itrate over entities
        foreach (index, value in this.__matched.entities) {
            if (value.table == UNDEFINED) throw "ORM.Query: couldn't find configured table name for: " + index;

            // replace data to table names
            query = ORM.Utils.String.replace("@" + index, value.table.tolower(), query);
        }

        // iterate over parameters
        foreach (index, value in this.__matched.parameters) {
            if (value == UNDEFINED) throw "ORM.Query: you didn't provided data for parameter: " + index;

            // replace data to table names
            query = ORM.Utils.String.replace(":" + index, value, query);
        }

        // save compiled version
        this.__compiled = query;

        return query;
    }

    /**
     * Function proxyies hydration of given data
     * to a specific entity hydrator
     * @return {ORM.Entity|mixed} Created and hydrated (populated with given data) entity or mixed data
     */
    function hydrate(data) {
        // return empty if empty, lol
        if (data.len() < 0) return data;

        // just proxy data if no special keys
        // (custom select fields case)
        if (!("_uid" in data && "_entity" in data)) return data;

        // extract entity class by name
        local entityClass = compilestring("return " + data._entity + ";")();

        // proxy hydration to entity class
        return entityClass.hydrate(data);
    }

    /**
     * Run query without processing the result
     * @param  {Function} callback
     */
    function execute(callback = null) {
        local query = this.compile();

        ORM.Driver.query(query, function(err, results) {
            return callback ? callback(err, err ? false : true) : null;
        });

        return this;
    }

    /**
     * Run query with processing the result for a single entity
     * @param  {Function} callback
     */
    function getSingleResult(callback) {
        local self = this;
        local query = this.compile();

        ORM.Driver.query(query, function(err, results) {
            if (err) return callback(err, null);

            // added return if no results
            if (!results) return callback(err, null);

            // extract and hydrate data
            local result = results[0];
            local hydrated = self.hydrate(result);

            // return it
            callback(null, hydrated);
        });

        return this;
    }

    /**
     * Run query with processing the result for a array of entities
     * @param  {Function} callback
     */
    function getResult(callback) {
        local self = this;
        local query = this.compile();

        ORM.Driver.query(query, function(err, results) {
            if (err) return callback(err, null);

            local hydrated = [];

            // iterate over data and hydrate it
            foreach (idx, data in results) {
                hydrated.push(self.hydrate(data));
            }

            // return it
            callback(null, hydrated);
        });

        return this;
    }
}
/**
 * ORM.Entity is a class that must be inherited
 * 
 * Entity is a equialent to a database table,
 * which have more convinient method to access, modify and store the data
 *
 * Every inherited entity must describe it's own table name;
 */
class ORM.Entity {
    
    /**
     * Didn't find any way to get current classname
     * so, we need to set it up manually
     * @type {String}
     */
    static classname = UNDEFINED;

    /**
     * Set up tablename that will be used for entity
     * @type {[type]}
     */
    static table = UNDEFINED;

    /**
     * Decleare empty fields and traits arrays
     * they will be used to populate our model with fields
     * and traits
     * @type {Array}
     */
    static fields = [];
    static traits = [];

    /**
     * Table with stored/loaded data
     * @type {Object}
     */
    __data = null;

    /**
     * Array that keeps names of modified fields
     * (changed since last save/load)
     * 
     * @type {Array}
     */
    __modified = null;

    /**
     * Field store information about 
     * fields that were attached to entity
     * 
     * @type {Object}
     */
    __fields = null;

    /**
     * Field that tracks if entity is destroyed
     * 
     * @type {Boolean}
     */
    __destroyed = false;

    /**
     * Field that tracks if the entity 
     * was ever persisted to storage
     * 
     * @type {Boolean}
     */
    __persisted = false;


    constructor() {
        if (this.classname == UNDEFINED) {
            throw "ORM.Entity: you've have to declare classname in your inherited entity class.";
        }

        this.__data = {};
        this.__modified = [];
        this.__fields = {};

        // this.__data["_uid"] <- _uid();
        // this.__data["_entity"] <- typeof(this);

        this.__attachField( ORM.Field.Id({ name = "_uid" }));
        this.__attachField( ORM.Field.String({ name = "_entity", value = this.classname }));

        // attach field described in entity class
        foreach (idx, field in this.fields) {
            this.__attachField(field);
        }

        // inherit traits described in entity class
        foreach (idx, trait in this.traits) {
            if (!(trait instanceof ORM.Trait.Interface)) {
                throw "ORM.Entity: you've tried to insert non-inherited trait. Dont do dis.";
            }

            // attach trait fields
            foreach (idx, field in trait.fields) {
                this.__attachField(field);
            }
            
            // registering methods of trait entities
            // foreach (idx, field in trait) {
            //     if (typeof(field) == "function") {
            //         dbg(idx);
            //     }
            // }
        }
    }

    /**
     * Attach (bind) field to this model
     * @param  {ORM.Field} field
     */
    function __attachField(field) {
        if (!(field instanceof ORM.Field.Basic)) {
            throw "ORM.Entity: you've tried to attach non-inherited field. Dont do dis.";
        }

        this.__data[field.__name] <- field.__value;
        this.__fields[field.__name] <- field;
    }

    /**
     * Method sets object field
     * and marks it as modified
     * 
     * @param {string} name
     * @param {mixed} value
     */
    function set(name, value) {
        return this[name] = value;
    }

    /**
     * Method gets value by field name
     * 
     * @param {string} name
     */
    function get(name) {
        return this[name];
    }

    /**
     * Meta impelemtation for set
     * @param {string} name
     * @param {mixed} value
     */
    function _set(name, value) {
        if (!name in this.__data) {
            throw null;
        }

        // set new data and mark as modified
        if (this.__data[name] != value) {
            this.__data[name] = value;
            this.__modified.push(name);
        }
    }

    /**
     * Meta implementation for get
     * @param  {string} name
     * @return {mixed}
     */
    function _get(name) {
        if (name in this.__data) {
            return this.__data[name];
        }

        throw null;
    }

    /**
     * Method exports data from model to plain object
     * @return {Object}
     */
    function export() {
        local object = {};

        foreach (idx, value in this.__data) {
            object[idx] <- value;
        }

        return object;
    }

    /**
     * Static method creates and "hydrates" 
     * (populates) model based on plain data
     * and returns created object
     * 
     * @param  {Object} data
     * @return {ORM.Entity}
     */
    static function hydrate(data) {
        local entity = this();

        // load data into model
        foreach (field, value in data) {
            if (field in entity.__data && field in entity.__fields) {
                entity.__data[field] = entity.__fields[field].decode(value);
            }
        }

        // entity came from storage
        entity.__persisted = true;

        return entity;
    }

    /**
     * Method creates new query table
     * @return {ORM.Query} [description]
     */
    function createTable() {
        // TODO: make static via self = this();
        local table_name = this.table.tolower();
        local table_fields = [];

        // compile fields data
        foreach (idx, field in this.__fields) {
            table_fields.push(field.__create());
        }

        // TODO: more custom index building

        // create query and fill data
        local query = ORM.Query("CREATE TABLE IF NOT EXISTS `:table` (:fields)");

        query.setParameter("table", table_name);
        query.setParameter("fields", ORM.Utils.Array.join(table_fields, ","));

        return query;
    }

    /**
     * Method will save entity data to a database
     * if entity has been previously persisted
     * it will try to update modified fields, if any
     *
     * In other case (new entity) it will try to insert
     * data to a database table and mark entity as persisted
     *
     * @param {function} callback optional
     */
    function save(callback = null) {
        local self = this;

        if (this.__persisted) {
            // exit if not modifed
            if (this.__modified.len() < 1) {
                // note: 3rd parameter (true) denotes that entity was not actually saved
                return callback ? callback(null, this, true) : this;
            }

            // create and execute cute query
            local query = ORM.Query("UPDATE `:table` SET :values WHERE `_uid` = :uid");

            query.setParameter("table", this.table);
            query.setParameter("values", ORM.Utils.Formatter.calculateUpdates(this));
            query.setParameter("uid", this.get("_uid"));

            return query.execute(callback);
        } else {
            // create and execute even cuter query
            local query = ORM.Query("INSERT INTO `:table` (:fields) VALUES (:values); SELECT LAST_INSERT_ID() as id;");

            query.setParameter("table", this.table);
            query.setParameter("fields", ORM.Utils.Formatter.calculateFields(this));
            query.setParameter("values", ORM.Utils.Formatter.calculateValues(this));

            // try to read result and save last inserted id
            // as current entity id, and mark as persisted
            return query.getSingleResult(function(err, result) {
                if (err && callback) return callback(err, null); 

                // TODO: test for last insert id for mysql&sqlite
                if (!("id" in result)) {
                    throw "ORM.Entity: coundn't assign id after insertion; check the query or smth else.";
                }

                self.__data["_uid"] = result["id"];
                self.__persisted = true;

                return callback ? callback(null, this) : null;
            });
        }

        return this;
    }

    /**
     * Remove entity from database
     */
    function remove(callback = null) {
        if (this.__persisted) {
            local query = ORM.Query("DELETE FROM `:table` WHERE `_uid` = :uid");

            query.setParameter("table", this.table);
            query.setParameter("uid", this.get("_uid"));

            return query.execute(callback);
        }

        return callback ? callback(null, null) : null;
    }

    /**
     * Method that tries to find all table entities
     * @param  {Function} callback
     */
    static function findAll(callback) {
        return ORM.Query("SELECT * FROM `:table`").setParameter("table", table).getResult(callback);
    }

    /**
     * Method that tries to find all queried entities
     * with mapping, by a special condition
     * @param  {Table|String}   condition
     * @param  {Function} callback
     */
    static function findBy(condition, callback) {
        local query = ORM.Query("SELECT * FROM `:table` :condition")
        
        query.setParameter("table", table);
        query.setParameter("condition", ORM.Utils.Formatter.calculateCondition(condition));

        return query.getResult(callback);
    }

    /**
     * Method that tries to find single queried entity
     * with mapping, by a special condition
     * @param  {Table|String}   condition
     * @param  {Function} callback
     */
    static function findOneBy(condition, callback) {
        local query = ORM.Query("SELECT * FROM `:table` :condition")
        
        query.setParameter("table", table);
        query.setParameter("condition", ORM.Utils.Formatter.calculateCondition(condition));

        return query.getSingleResult(callback);
    }

    /**
     * Helper method tostring, returns classname
     * @return {String}
     */
    function _tostring() {
        return this.classname;
    }

    // TODO: make entities able to detach and clear memory
    function detach() {}
    function clean() {}
}
