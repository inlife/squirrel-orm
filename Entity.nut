class ORM.Entity {
    static table = UNDEFINED;
    static fields = [];
    static traits = [];

    /**
     * Table with stored/loaded data
     * @type {Object}
     */
    __data = {};

    /**
     * Array that keeps names of modified fields
     * (changed since last save/load)
     * 
     * @type {Array}
     */
    __modified = [];

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
        this.__data["_uid"] <- _uid();
        this.__data["_entity"] <- typeof(this);
    }

    /**
     * Method sets object field
     * and marks it as modified
     * 
     * @param {string} name
     * @param {mixed} value
     */
    function set(name, value) {
        dbg("setting " + name + " " + value + " in " + this.table);
    }

    /**
     * Method gets value by field name
     * 
     * @param {string} name
     */
    function get(name) {

    }

    function save() {}
    function remove() {}

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

        entity.set("lol", "lal");

        return this;
    }

    static function findAll() {
        ::print("finding all");
        ::print(this.fields[0].name);
    }
    static function findBy() {}
    static function findOneBy() {}
}
