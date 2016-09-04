class ORM.Utils.String {
    
    /**
     * Replace occurances of "search" to "replace" in the "subject"
     * @param  {string} search
     * @param  {string} replace
     * @param  {string} subject
     * @return {string}
     */
    static function replace(search, replace, subject) {
        local string = "";
        local first = subject.find(search[0].tochar());
        local last = (typeof first == "null" ? null : subject.find(
            search[(search.len()-1)].tochar(), first
        ));

        if (typeof first == "null" || typeof last == "null") return false;

        for (local i = 0; i < subject.len(); i++) {
            if (i >= first && i <= last) {
                if (i == first) string = format("%s%s", string, replace.tostring());
            } else { 
                string = format("%s%s", string, subject[i].tochar());
            }
        }

        return string;
    }
}
