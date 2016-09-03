require("./Field");
require("./Entity");
require("./TraitInterface");
require("./Positionable");

class Account extends ORM.Entity {
    
    /**
     * Set up table name
     * TODO: make automatic?
     * @type {String}
     */
    static table = "tbl_accounts";

    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        ORM.Field({ name = "username", type = "string", size = 255 }),
        ORM.Field({ name = "password", type = "string", size = 255 }),
        ORM.Field({ name = "createdAt", type = "timestamp" })
    ];

    /**
     * Set up traits
     * (predefined collections of fields)
     * @type {Array}
     */
    static traits = [
        ORM.Trait.Positionable()
    ];
}
