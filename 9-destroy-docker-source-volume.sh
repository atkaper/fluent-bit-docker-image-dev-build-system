#!/bin/bash

echo "Sure? Hit ctrl-break to cancel, hit enter to remove volume"
read
docker volume rm fluent-bit-src-volume
