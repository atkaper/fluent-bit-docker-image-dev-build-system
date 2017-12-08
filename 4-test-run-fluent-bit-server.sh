#!/bin/bash

echo "hit ctrl-break to exit"
echo "Run next command from another command line:"
echo '   docker run --rm --name tst --log-driver=fluentd -t ubuntu echo "Testing a log message"'
echo
echo
docker run -ti --rm --name fluent-bit -p 127.0.0.1:24224:24224 local/fluent-bit

