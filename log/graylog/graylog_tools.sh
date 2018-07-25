#!/bin/env bash

for i in `seq 10`
do
    echo -n '{ "version": "1.1", "host": "jmeter", "short_message": "[None Log] Nickname:CE4A212PK, GlobalId:2364405440937 ------send byte = 20742,receive byte = 241359", "level": 5, "_some_info": "foo" }' | nc -w 1 -u 10.0.0.2 12201
done
