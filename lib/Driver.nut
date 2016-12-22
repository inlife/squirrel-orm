class ORM.Driver {
    static storage = {
        proxy = null,
        provider = "mysql",
        configured = false
    };

    constructor () {

    }

    /**
     * Method for configuration current connectins
     */
    function configure(settings = null) {
        storage.provider = "provider" in settings ? settings.provider : storage.provider;
    }

    function setProxy(callback) {
        storage.proxy = callback;
        storage.configured = true;
    }

    function query(queryString, callback) {
        if (!storage.configured) throw "ORM.Driver: you didn't configure the driver";
        storage.proxy(queryString, callback);
    }
}
