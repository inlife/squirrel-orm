/**
 * Class for creating and executing SQL queries
 * Examples:
 *     Query("select * from @MyEntity").getResult()
 *     Query("select p.id, d.size from tbl_p p left join tbl_d d on d.id = p.size_id where p.id = :id").setParameter('id', 15).getSingleResult()
 *     Query("delete from @MyEntity").getResult()
 */
class ORM.Query {
    
    /**
     * Field stores current raw query
     * @type {string}
     */
    __raw = null;

    /**
     * Field with table of predefined 
     * regex expressions for matching in parse method
     * @type {Object}
     */
    __regex = {
        entityName = regexp("@[A-Za-z_]+"),
        parameters = regexp(":[A-Za-z_]+")
    };

    /**
     * Field storage for matched data after parse method
     * (storing named entities and parameters)
     * @type {Object}
     */
    __matched = null;

    constructor (queryString) {
        // fill in default data
        this.__matched = {
            entities = {},
            parameters = {}
        };

        // save plain raw query string
        this.__raw = queryString;

        // start parsing, and 
        // throw errors if any found
        this.parse(queryString);
    }

    /**
     * Method tries to parse raw query
     * throws error if entities, matched in query was not found in global namespace
     * @param  {string} queryString
     */
    function parse(queryString) {
        // search for entity names in query
        local previousPosition = 0; 
        while (true) {
            local results = this.__regex.entityName.search(
                queryString, previousPosition
            );

            if (!results) break;

            // extract entity name
            local entityName = queryString.slice(results.begin + 1, results.end);

            try {
                // extract entity class by name
                local entityClass = compilestring("return " + entityName + ";")();

                // save it to local storage
                this.__matched.entities[entityName] <- entityClass;
            } catch (e) {
                throw "ORM.Query: tried to access to non-declared entity: " + entityName
                     + "\n in query: " + this.__raw;
            }

            previousPosition = results.end;
        }

        // search for params in query
        previousPosition = 0; 
        while (true) {
            local results = this.__regex.parameters.search(
                queryString, previousPosition
            );

            if (!results) break;

            // extract parameter name
            local paramName = queryString.slice(results.begin + 1, results.end);

            // save it to local storage
            this.__matched.parameters[paramName] <- UNDEFINED;

            previousPosition = results.end;
        }
    }

    /**
     * Sets a value binded to parameter name
     * throws error if parameter was not created
     * @param {string} name
     * @param {mixed} value
     */
    function setParameter(name, value) {
        // TODO: add validation and escaping to "value"

        try {
            this.__matched.parameters[name] = value;
        } catch (e) {
            throw "ORM.Query: tried to populate unregistered parameter: " + name
                 + "\n in query: " + this.__raw;
        }

        return this;
    }

    function getResult() {
        return [];
    }

    function getSingleResult() {
        return null;
    }
}
