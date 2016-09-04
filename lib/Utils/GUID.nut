ORM.Utils["GUID"] <- function (length = 8) {
    // TODO: add shuffle
    local symbols = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";
    local string = "";

    if (first > 0) {
        srand((rand() & time()) * clock());
        first--;
    }

    for (local i = 0; i < length; i++) {
        local pos = rand() % symbols.len();
        string += symbols.slice(pos, pos + 1);
    }

    return string;
}
