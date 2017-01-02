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
     * Is this a SQLite implementation of the field
     * @type {Boolean}
     */
    __sqlite = false;

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
        this.__primary  = "primary"  in data ? data.primary  : this.__primary;
        this.__nullable = "nullable" in data ? data.nullable : this.__nullable;
        this.__autoinc  = "autoinc"  in data ? data.autoinc  : this.__autoinc;
        this.__exported = "exported" in data ? data.exported : this.__exported;

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
        local autoinc   = this.__autoinc  ? "AUTO_INCREMENT" : "";
        local primary   = this.__primary  ? "PRIMARY KEY" : "";

        // special override for sqlite
        if (ORM.Driver.storage.provider == "sqlite") {

            // autoincrement field
            if (autoinc != "") {
                autoinc = "AUTOINCREMENT";
                type = "INTEGER";
            }
        }

        // default value
        local defval = this.__value && this.__name != "_entity" ? "DEFAULT " + ORM.Utils.Formatter.escape( this.encode(this.__value) ) : "";

        // insert and return;
        return strip(format("`%s` %s %s %s %s %s",
            this.getName(), type, nullable, primary, autoinc, defval
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
