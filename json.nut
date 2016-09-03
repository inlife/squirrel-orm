class json {

    function decode(string) {
        local _compile = compilestring("return " + stripLines(string));
        
        return _compile();
        //return recursivedecode(_compile());
    }

    function recursivedecode(data) {
        foreach(i, val in data) {
            if (typeof(val) == "array" || typeof(val) == "table") {
                data[i] = recursivedecode(val);
            } else if (typeof(val) == "string") {
                data[i] = htmldecode(val);
            }
        }
        return data;
    }
    
    function stripLines(string) {
        local _split = split(string, "\r\n");
        string = "";
        
        foreach(_string in _split) string += _string;
        
        return string;
    }

    function htmlencode(str) {
        //str = strrep(str, "\"", "$30-");
        //str = strrep(str, "'", "$31-");
        str = str_replace(str, "[", "$32-");
        str = str_replace(str, "]", "$33-");
        str = str_replace(str, "{", "$34-");
        str = str_replace(str, "}", "$35-");
        return str;
    }

    function htmldecode(str) {
        //str = strrep(str, "$30-", "'");
        //str = strrep(str, "$31-", "\"");
        str = str_replace(str, "$32-", "[");
        str = str_replace(str, "$33-", "]");
        str = str_replace(str, "$34-", "{");
        str = str_replace(str, "$35-", "}");
        return str;
    }

    function encode(var) {
        local _string;
        
        switch(typeof(var)) {
            case "bool":
            case "integer":
                return "\"" + var.tointeger() + "\"" ;
            
            case "string":
            case "float":
                return "\"" + var.tostring() + "\"";
                
            case "array":
                _string = "[";
                foreach(key, element in var) {
                    local _string_2 = encode(element);
                    if(_string_2 == null)
                        return null;
                    _string += _string_2 +(key+1 < var.len() ? "," : "");
                
                }
                
                _string += "]";
                return _string;
                
            case "table":
                _string = "{";
                local _i = 0;
                foreach(key, value in var) {
                    _i++;
                    local _key = encode(key);
                    if(_key == null)
                        return null;
                    local _value = encode(value);
                    if(_value == null)
                        return null;

                    _string += _key + ":" + _value +(_i < var.len() ? "," : "");
                }
                
                _string += "}";
                return _string;

            default:
                return null;
        }
    }
}
