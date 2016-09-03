class ORM.Trait.Positionable extends ORM.Trait.Interface {

    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        ORM.Field({ name = "x", type = "float" }, 0.0),
        ORM.Field({ name = "y", type = "float" }, 0.0),
        ORM.Field({ name = "z", type = "float" }, 0.0)
    ];

    function setPosition() {

    }

    function getPosition() {
        
    }
}
