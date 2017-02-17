class ORM.Utils.Formatter {
    /**
     * Method calculates changes for the entity
     * and transofrms them into a string for a query
     * @param  {ORM.Entity} entity
     * @return {String}
     */
    static function calculateUpdates(entity) {
        local result = [];

        foreach (idx, field in entity.fields) {
            if (entity.__modified.find(field.__name) != null) {
                result.push(format("`%s` = ", field.getName()) + this.escape( field.encode(entity.__data[field.__name]) ));
            }
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

        foreach (idx, field in entity.fields) {
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

        foreach (idx, field in entity.fields) {
            if (field instanceof ORM.Field.Id) continue;
            result.push(this.escape( field.encode(entity.__data[field.__name]) ));
        }

        return ORM.Utils.Array.join(result, ",");
    }

    /**
     * Method calculates condition for the entity
     * and transofrms them into a string for a query
     * @param  {ORM.Entity} entity
     * @return {String}
     */
    static function calculateCondition(condition) {
        if (typeof(condition) == "string") {
            return "WHERE " + condition;
        }

        if (typeof(condition) != "table") {
            throw "ORM.Query: you have to provide table or a string as a condition to a query";
        }

        // skip if empty
        if (condition.len() < 1) {
            return "";
        }

        local result = [];

        foreach (name, value in condition) {
            result.push(format("`%s` = %s", name, this.escape(value)));
        }

        return "WHERE " + ORM.Utils.Array.join(result, " AND ");
    }

    /**
     * Escape value
     * @param  {Mixed} value
     * @return {Mixed}
     */
    static function escape(value) {
        return (typeof(value) == "string" ? "'" + ORM.Utils.String.escape(value) + "'" : (value != null ? value.tostring() : "NULL"));
    }
}
