#include "example.h"
#include <gdbm.h>

int main (int argc, char *argv[])
{
    GDBM_FILE db;
    db = gdbm_open("example.db", 0, GDBM_READER, 0666, 0);

    datum key, data;
    key.dsize = strlen(argv[1]) + 1;
    data = gdbm_fetch(db, key);

    gdbm_close(db);

    return 0;
}
