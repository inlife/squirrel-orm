class ORM.Entity {
    static table = UNDEFINED;

    static __mapping = {};

    constructor() {
        dbg("orm.entity called");
    }

    /**
     * Method sets object field
     * and marks it as modified
     * @param {string} name
     * @param {mixed} value
     */
    function set(name, value) {
        dbg("setting " + name + " " + value + " in " + this.table);
    }

    /**
     * Method gets value by field name
     * @param {string} name
     */
    function get(name) {

    }

    /**
     * Static method "hydrates" (populates) model based on plain data
     * and returns created object
     * @param  {Object} data
     * @return {ORM.Entity}
     */
    static function hydrate(data) {
        local entity = this();

        entity.set("lol", "lal");

        return this;
    }

    function save() {}
    function remove() {}
    function findAll() {
        ::print("finding all");
        ::print(this.fields[0].name);
    }
    function findBy() {}
    function findOneBy() {}

    // function _newmember(index, value, attributes, isstatic) {
    //     this[index] <- value;

    //     if (index == "table") {
    //         this.__mapping[index] <- this;
    //     }
    // }
}
