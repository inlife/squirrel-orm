class ORM.Utils.ChangeTracker {
    /**
     * Method calculates changes for the entity
     * and transofrms them into a string for a query
     * @param  {ORM.Entity} entity
     * @return {String}
     */
    static function calculateUpdates(entity) {
        local result = [];

        foreach (idx, name in entity.__modified) {
            local field = entity.__fields[name];
            local value = entity.__data[name];

            result.push(format("`%s` = %s", field.getName(), field.encode(value)));
        }

        return ORM.Utils.Array.join(result, ",");
    }

    /**
     * Method calculates field names for insertion of the entity
     * and transofrms them into a string for a query
     * @param  {ORM.Entity} entity
     * @return {String}
     */
    static function calculateFields(entity) {
        local result = [];

        foreach (name, field in entity.__fields) {
            if (field instanceof ORM.Field.Id) continue;
            result.push(format("`%s`", field.getName()));
        }

        return ORM.Utils.Array.join(result, ",");
    }

    /**
     * Method calculates field values for insertion of the entity
     * and transofrms them into a string for a query
     * @param  {ORM.Entity} entity
     * @return {String}
     */
    static function calculateValues(entity) {
        local result = [];

        foreach (name, field in entity.__fields) {
            if (field instanceof ORM.Field.Id) continue;
            result.push(field.encode(entity.__data[name]));
        }

        return ORM.Utils.Array.join(result, ",");
    }
}
