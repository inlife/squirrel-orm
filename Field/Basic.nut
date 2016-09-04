/**
 * Basic class for field
 * Can be used directly, or (much better) inherited
 */
class ORM.Field.Basic {

    /**
     * Name of field
     * @type {String}
     */
    __name = UNDEFINED;

    /**
     * Field type
     * @type {String}
     */
    __type = "string";

    /**
     * Field size (yea, some fields have 'em)
     * @type {Number}
     */
    __size = 255;

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
     * Is this field will be exported on Entity.export
     * @type {Boolean}
     */
    __exported = true;

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

        // convert to lower and save
        this.__name = data.name.tostring().tolower();

        // check and save others
        this.__type     = "type"    in data ? data.type     : "string";
        this.__size     = "size"    in data ? data.size     : 255;
        this.__value    = "value"   in data ? data.value    : null;
        this.__primary  = "primary" in data ? data.primary  : false;
    }
    
    function encode(currentValue) {

    }

    function decode(encodedValue) {

    }
}
