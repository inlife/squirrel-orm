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
     * @type {String}
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
     * Inner storage for initialized entities
     * @type {Object}
     */
    static __initialized = {};

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

        if (this.table == UNDEFINED) {
            throw "ORM.Entity: you have to declare table name for your entity class " + this.classname;
        }

        // set up emtpty data storages
        this.__data = {};
        this.__modified = [];

        // call init (calls only one time per entity)
        this.initialize();

        // fill in default values
        foreach (idx, field in this.fields) {
            this.__data[field.__name] <- field.__value;
        }
    }

    function initialize() {
        if (this.classname in this.__initialized) {
            return;
        }

        // validate user-defined fields
        foreach (idx, field in this.fields) {
            if (!(field instanceof ORM.Field.Basic)) {
                throw "ORM.Entity: you've tried to attach non-inherited field. Dont do dis.";
            }

            this.fields[idx] = clone(field);
        }

        // special check for extended entity class
        if (this.fields.len() > 1) {
            // id exists, which means we are inhariting some entity
            if (this.fields[0].getName() == "id") {
                this.fields.remove(1);
                this.fields.remove(0);
            }
        }

        // reverse current defined fields (to add at the beginning)
        this.fields.reverse();

        // add default fields
        this.fields.push(ORM.Field.String({ name = "_entity", value = this.classname }));
        this.fields.push(ORM.Field.Id({ name = "id" }));

        // reverse back to normal order
        this.fields.reverse();

        // inherit traits described in entity class
        foreach (idx, trait in this.traits) {
            if (!(trait instanceof ORM.Trait.Interface)) {
                throw "ORM.Entity: you've tried to insert non-inherited trait. Dont do dis.";
            }

            // attach trait fields
            foreach (idx, field in trait.fields) {
                this.fields.push(field);
            }

            // registering methods of trait entities
            // foreach (idx, field in trait) {
            //     if (typeof(field) == "function") {
            //         dbg(idx);
            //     }
            // }
        }

        // set as initialized (preventing double run)
        this.__initialized[this.classname] <- 1;

        // create table if not exists
        this.createTable().execute();
    }

    /**
     * Meta impelemtation for set
     *
     * @param {string} name
     * @param {mixed} value
     */
    function _set(name, value) {
        return this.set(name, value);
    }

    /**
     * Meta implementation for get
     *
     * @param {string} name
     */
    function _get(name) {
        return this.get(name);
    }

    /**
     * Method sets object field
     * and marks it as modified
     * @param {string} name
     * @param {mixed} value
     */
    function set(name, value) {
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
     * Method gets value by field name
     * @param  {string} name
     * @return {mixed}
     */
    function get(name) {
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

        // try to load given data into model
        foreach (idx, field in entity.fields) {
            if (field.__name in data) {
                entity.__data[field.__name] = field.decode(data[field.__name]);
            } else {
                entity.__data[field.__name] = field.__value;
            }
        }

        // entity came from storage
        entity.__persisted = true;
        entity.hydrated();

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
        foreach (idx, field in this.fields) {
            table_fields.push(field.__create());
        }

        // TODO: more custom index building

        // create query and fill data
        local query = ORM.Query("CREATE TABLE IF NOT EXISTS `:table` (:fields)");

        query.setParameter("table", table_name, true);
        query.setParameter("fields", ORM.Utils.Array.join(table_fields, ","), true);

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
            local query = ORM.Query("UPDATE `:table` SET :values WHERE `id` = :id");

            query.setParameter("table", this.table, true);
            query.setParameter("values", ORM.Utils.Formatter.calculateUpdates(this), true);
            query.setParameter("id", this.get("id"));

            return query.execute(callback);
        } else {
            // create and execute even cuter query
            // local lastid = "LAST_INSERT_ID";

            // // special check for sqlite
            // if (ORM.Driver.storage.provider == "sqlite") {
            //     lastid = "last_insert_rowid";
            // }

            local query = ORM.Query("INSERT INTO `:table` (:fields) VALUES (:values);");

            query.setParameter("table", this.table, true);
            query.setParameter("fields", ORM.Utils.Formatter.calculateFields(this), true);
            query.setParameter("values", ORM.Utils.Formatter.calculateValues(this), true);
            // query.setParameter("lastid", lastid);

            // try to read result and save last inserted id
            // as current entity id, and mark as persisted
            return query.getSingleResult(function(err, result) {
                if (err && callback) return callback(err, null);

                // TODO: test for last insert id for mysql&sqlite
                if (!("id" in result)) {
                    throw "ORM.Entity: coundn't assign id after insertion; check the query or smth else.";
                }

                self.__data["id"] = result["id"];
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
            local query = ORM.Query("DELETE FROM `:table` WHERE `id` = :id");

            query.setParameter("table", this.table, true);
            query.setParameter("id", this.get("id"));

            return query.execute(callback);
        }

        return callback ? callback(null, null) : null;
    }

    /**
     * Method that tries to find all table entities
     * @param  {Function} callback
     */
    static function findAll(callback) {
        // call init (calls only one time per entity)
        this.initialize();

        return ORM.Query("SELECT * FROM `:table`").setParameter("table", table, true).getResult(callback);
    }

    /**
     * Method that tries to find all queried entities
     * with mapping, by a special condition
     * @param  {Table|String}   condition
     * @param  {Function} callback
     */
    static function findBy(condition, callback) {
        // call init (calls only one time per entity)
        this.initialize();

        local query = ORM.Query("SELECT * FROM `:table` :condition")

        query.setParameter("table", table, true);
        query.setParameter("condition", ORM.Utils.Formatter.calculateCondition(condition), true);

        return query.getResult(callback);
    }

    /**
     * Method that tries to find single queried entity
     * with mapping, by a special condition
     * @param  {Table|String}   condition
     * @param  {Function} callback
     */
    static function findOneBy(condition, callback) {
        // call init (calls only one time per entity)
        this.initialize();

        local query = ORM.Query("SELECT * FROM `:table` :condition LIMIT 1")

        query.setParameter("table", table, true);
        query.setParameter("condition", ORM.Utils.Formatter.calculateCondition(condition), true);

        return query.getSingleResult(callback);
    }

    /**
     * Helper method tostring, returns classname
     * @return {String}
     */
    function _tostring() {
        return this.classname;
    }

    function _serialize() {
        return this.export();
    }

    function hydrated() {

    }

    function clean() {

    }

    // TODO: make entities able to detach
    function detach() {}
}
