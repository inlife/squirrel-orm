class ORM.Field {
    name = UNDEFINED;
    type = "string";
    size = 255;

    constructor (data) {
        this.name = data.name;
        this.type = data.type;
        this.size = "size" in data ? data["size"] : 0;
    }
}
