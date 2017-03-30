local Text = require("./text");

class String extends Text
{
    static type = "varchar";
    static size = 255;
}

module.exports = String;
