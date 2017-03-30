local Inteface = require("./interface");
local fileds   = require("../fields");

class Positionable extends Inteface
{
    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        fields.Float({ name = "x" }),
        fields.Float({ name = "y" }),
        fields.Float({ name = "z" })
    ];
}

module.exports = Positionable;
