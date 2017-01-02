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

    /**
     * Escape strings according to http://www.json.org/ spec
     * @param {String} str
     */
    function escape(str) {
        local res = "";

        for (local i = 0; i < str.len(); i++) {

            local ch1 = (str[i] & 0xFF);

            if ((ch1 & 0x80) == 0x00) {
                // 7-bit Ascii

                ch1 = format("%c", ch1);

                if (ch1 == "\'") {
                    res += "\\\'";
                } else if (ch1 == "\"") {
                    res += "\\\"";
                } else if (ch1 == "\\") {
                    res += "\\\\";
                } else if (ch1 == "/") {
                    res += "\\/";
                } else if (ch1 == "\b") {
                    res += "\\b";
                } else if (ch1 == "\f") {
                    res += "\\f";
                } else if (ch1 == "\n") {
                    res += "\\n";
                } else if (ch1 == "\r") {
                    res += "\\r";
                } else if (ch1 == "\t") {
                    res += "\\t";
                } else if (ch1 == "\0") {
                    res += "\\u0000";
                } else {
                    res += ch1;
                }

            } else {

                if ((ch1 & 0xE0) == 0xC0) {
                    // 110xxxxx = 2-byte unicode
                    local ch2 = (str[++i] & 0xFF);
                    res += format("%c%c", ch1, ch2);
                } else if ((ch1 & 0xF0) == 0xE0) {
                    // 1110xxxx = 3-byte unicode
                    local ch2 = (str[++i] & 0xFF);
                    local ch3 = (str[++i] & 0xFF);
                    res += format("%c%c%c", ch1, ch2, ch3);
                } else if ((ch1 & 0xF8) == 0xF0) {
                    // 11110xxx = 4 byte unicode
                    local ch2 = (str[++i] & 0xFF);
                    local ch3 = (str[++i] & 0xFF);
                    local ch4 = (str[++i] & 0xFF);
                    res += format("%c%c%c%c", ch1, ch2, ch3, ch4);
                }

            }
        }

        return res;
    }

}
