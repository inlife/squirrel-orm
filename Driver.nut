class ORM.Driver {
    static storage = {
        proxy = null,
        configured = false
    };

    constructor () {
        
    }

    function configure() {

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
