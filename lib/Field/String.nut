class ORM.Field.String extends ORM.Field.Basic {
    static type = "varchar";
    static size = 255;
    static value = "";
    
    /**
     * Method that encodes value
     * according to field class
     * @param  {Mixed} currentValue
     * @return {Mixed}
     */
    function encode(currentValue) {
        return format("'%s'", currentValue.tostring());
    }

    /**
     * Method that decodes value
     * according to field class
     * @param  {Mixed} encodedValue
     * @return {Mixed}
     */
    function decode(encodedValue) {
        return encodedValue.tostring();
    }
}
