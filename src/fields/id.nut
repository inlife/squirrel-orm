local Integer = require("./integer");

class Id extends Integer
{
    __primary = true;
    __autoinc = true;
}

module.exports = Id;
