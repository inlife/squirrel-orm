class ORM.Trait.Positionable extends ORM.Trait.Interface {

    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        ORM.Field.Float({ name = "x" }),
        ORM.Field.Float({ name = "y" }),
        ORM.Field.Float({ name = "z" })
    ];
}
