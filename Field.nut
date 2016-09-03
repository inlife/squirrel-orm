class ORM.Field {
    name = UNDEFINED;
    type = "string";
    size = 255;
    value = null;

    constructor (data, defaultValue = null) {
        this.name = data.name;
        this.type = data.type;
        this.size = "size" in data ? data["size"] : 0;
        this.value = defaultValue;
    }
}
