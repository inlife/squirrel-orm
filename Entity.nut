class ORM.Entity {
    static table = UNDEFINED;

    static __mapping = {};

    constructor() {
        ::print("orm.entity called");
    }

    /**
     * Method sets object field
     * and marks it as modified
     * @param {string} name
     * @param {mixed} value
     */
    function set(name, value) {

    }

    /**
     * Method gets value by field name
     * @param {string} name
     */
    function get(name) {

    }

    /**
     * Method "hydrates" (populates) model based on plain data
     * and returns created object
     * @param  {Object} data
     * @return {ORM.Entity}
     */
    function hydrate(data) {
        
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
