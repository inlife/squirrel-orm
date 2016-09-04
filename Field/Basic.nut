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
    static size = 255;

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
        this.__exported = "exported" in data ? data.exported : true;
        this.__nullable = "nullable" in data ? data.nullable : false;

        // handle the default value
        if ("value" in data) {
            this.__value = data.value;
        } else if (this.value != UNDEFINED) {
            this.__value = this.value;
        }
    }
    
    function encode(currentValue) {

    }

    function decode(encodedValue) {

    }
}
