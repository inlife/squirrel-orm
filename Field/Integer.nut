class ORM.Field.Integer extends ORM.Field.Basic {
    constructor (data) {
        base.constructor(data);
        
        // redefine some fields
        this.__type = "type" in data ? data.type : "integer";
    }
}
