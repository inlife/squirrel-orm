class ORM.Field.Bool extends ORM.Field.Basic {
    constructor (data) {
        base.constructor(data);
        
        // redefine some fields
        this.__type = "type" in data ? data.type : "boolean";
        this.__size = "size" in data ? data.size : 1;
    }
}
