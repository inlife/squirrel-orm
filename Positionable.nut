class ORM.Trait.Positionable extends ORM.Trait.Interface {

    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        ORM.Field({ name = "x", type = "float" }),
        ORM.Field({ name = "y", type = "float" }),
        ORM.Field({ name = "z", type = "float" })
    ];

    function setPosition() {

    }

    function getPosition() {
        
    }
}
