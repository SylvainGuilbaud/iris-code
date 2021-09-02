#!/bin/bash

docker-compose -p m down

cd demo
./demo/deleteDurableSYS.sh
