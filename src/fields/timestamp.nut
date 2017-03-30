local Basic = require("./basic");

class Timestamp extends Basic
{
    static type = "timestamp";
    static value = "CURRENT_TIMESTAMP()";
}

module.exports = Timestamp;
