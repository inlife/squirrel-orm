class ORM.Field.Password extends ORM.Field.Basic {
    constructor (data) {
        base.constructor(data);
        
        // TODO: need to add some special convertation (hashing)

        // redefine some fields
        this.__type = "type" in data ? data.type : "string";
    }
}
