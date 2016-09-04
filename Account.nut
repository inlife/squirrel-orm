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
        ORM.Field.String({ name = "username", }),
        ORM.Field.Password({ name = "password" }),
        ORM.Field.Timestamp({ name = "createdAt" })
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
