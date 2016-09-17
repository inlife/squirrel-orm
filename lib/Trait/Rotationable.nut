class ORM.Trait.Rotationable extends ORM.Trait.Interface {

    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        ORM.Field.Float({ name = "rx" }),
        ORM.Field.Float({ name = "ry" }),
        ORM.Field.Float({ name = "rz" })
    ];
}
