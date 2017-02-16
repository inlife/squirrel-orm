class ORM.Field.Integer extends ORM.Field.Basic {
    static type = "int";
    static value = 0;
    static size = 255;

    /**
     * Method that encodes value
     * according to field class
     * @param  {Mixed} currentValue
     * @return {Mixed}
     */
    function encode(currentValue) {
        return currentValue != null ? currentValue.tointeger() : null;
    }

    /**
     * Method that decodes value
     * according to field class
     * @param  {Mixed} encodedValue
     * @return {Mixed}
     */
    function decode(encodedValue) {
        return encodedValue != null ? encodedValue.tointeger() : null;
    }
}
