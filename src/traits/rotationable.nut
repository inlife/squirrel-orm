local Interface = require("./interface");
local fields    = require("../fields");

class Rotationable extends Interface
{
    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        fields.Float({ name = "rx" }),
        fields.Float({ name = "ry" }),
        fields.Float({ name = "rz" })
    ];
}

module.exports = Rotationable;
