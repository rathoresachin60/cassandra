#!/bin/bash

ps -aef |grep  $1 |grep -v grep|grep -v psrch | awk 'BEGIN{FS="\t"} { print substr($1,1, 200) }'

