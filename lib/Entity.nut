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
            local lastid = "LAST_INSERT_ID";

            // special check for sqlite
            if (ORM.Driver.storage.provider == "sqlite") {
                lastid = "last_insert_rowid";
            }

            local query = ORM.Query("INSERT INTO `:table` (:fields) VALUES (:values); SELECT :lastid() as id;");

            query.setParameter("table", this.table);
            query.setParameter("fields", ORM.Utils.Formatter.calculateFields(this));
            query.setParameter("values", ORM.Utils.Formatter.calculateValues(this));
            query.setParameter("lastid", lastid);

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
        local query = ORM.Query("SELECT * FROM `:table` :condition LIMIT 1")
        
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
