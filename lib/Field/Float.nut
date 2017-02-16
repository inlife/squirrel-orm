class ORM.Field.Float extends ORM.Field.Basic {
    static type = "float";
    static value = 0.0;

    /**
     * Method that encodes value
     * according to field class
     * @param  {Mixed} currentValue
     * @return {Mixed}
     */
    function encode(currentValue) {
        return currentValue != null ? currentValue.tofloat() : null;
    }

    /**
     * Method that decodes value
     * according to field class
     * @param  {Mixed} encodedValue
     * @return {Mixed}
     */
    function decode(encodedValue) {
        return encodedValue != null ? encodedValue.tofloat() : null;
    }
}
