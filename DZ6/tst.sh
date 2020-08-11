#!/bin/bash

cd /opt/LogCHK/
head -150 access-4560-644067.log >access.log
/opt/LogCHK/logchk.sh

head -250 access-4560-644067.log >access.log
/opt/LogCHK/logchk.sh

head -700 access-4560-644067.log >access.log
/opt/LogCHK/logchk.sh