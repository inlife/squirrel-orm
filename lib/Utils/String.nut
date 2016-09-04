class ORM.Utils.String {
    
    /**
     * Replace occurances of "search" to "replace" in the "subject"
     * @param  {string} search
     * @param  {string} replace
     * @param  {string} subject
     * @return {string}
     */
    function replace(original, replacement, string) {
        local expression = regexp(original);
        local result = "";
        local position = 0;
        local captures = expression.capture(string);

        while (captures != null) {
            foreach (i, capture in captures) {
                result += string.slice(position, capture.begin);
                result += replacement;
                position = capture.end;
            }

            captures = expression.capture(string, position);
        }

        result += string.slice(position);

        return result;
    }

}
