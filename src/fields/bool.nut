local Basic = require("./basic");

class Bool extends Basic
{
    static type = "tinyint";
    static size = 1;

    /**
     * Method that encodes value
     * according to field class
     * @param  {Mixed} currentValue
     * @return {Mixed}
     */
    function encode(currentValue) {
        return currentValue.tointeger();
    }

    /**
     * Method that decodes value
     * according to field class
     * @param  {Mixed} encodedValue
     * @return {Mixed}
     */
    function decode(encodedValue) {
        return encodedValue.tointeger() == 1;
    }
}

module.exports = Bool;
