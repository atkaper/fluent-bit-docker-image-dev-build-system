#!/bin/bash

echo "hit ctrl-break to exit"
echo
echo
docker run -ti --rm --name fluent-bit -p 127.0.0.1:24224:24224 local/fluent-bit /fluent-bit/bin/fluent-bit -i dummy -o stdout

