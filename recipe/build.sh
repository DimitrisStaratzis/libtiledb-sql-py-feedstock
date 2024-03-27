#!/bin/bash

set -e
set -x

FLAGS_NEEDED="-Wno-error=implicit-function-declaration"
if [[ $target_platform == osx-arm64  ]]; then
  export CFLAGS="${CFLAGS-} ${FLAGS_NEEDED}"
  export CXXFLAGS="${CXXFLAGS-} ${FLAGS_NEEDED}"
fi

echo '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++';
pwd;
echo '=================================================================================';
ls -l;

# debug
sed -i -e 's/#include "mysql.h"/#if __has_include(<mysql\/mysql.h>)\n#include <mysql\/mysql.h>\n#endif/g' tiledb/sql/_mysql.c
sed -i -e 's/#include "mysqld_error.h"/#include <mysql\/mysqld_error.h>/g' tiledb/sql/_mysql.c
sed -i -e 's/#include "errmsg.h"/#include <mysql\/errmsg.h>/g' tiledb/sql/_mysql.c

echo "Replacement complete."

cat tiledb/sql/_mysql.c;

$PYTHON setup.py install --single-version-externally-managed --record record.txt
