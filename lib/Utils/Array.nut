class ORM.Utils.Array {
    /**
     * Join array using sep as separator
     * Author: @Stormeus
     * http://forum.vc-mp.org/?topic=3226.0
     *
     * @param  {Array} arr
     * @param  {String} sep
     * @return {String}
     */
    static function join(arr, sep) {
        if (typeof(arr) != "array") {
            throw "join_array expected array input, got " + typeof(arr) + " (" + arr + ")";
        } else if (typeof(sep) != "string") {
            throw "join_array expected string separator, got " + typeof(sep) + " (" + sep + ")";
        } else if (arr.len() <= 0) {
            return "";
        }

        return arr.reduce(@(a, b) a + sep + b);
    }
}
