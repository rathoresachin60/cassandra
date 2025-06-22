#!/bin/bash
nodetool -u rsacassandra -pw ******! garbagecollect -- $1 $2
nodetool -u rsacassandra -pw ******! garbagecollect -- $1 $2
nodetool -u rsacassandra -pw ******! compact -s -- $1 $2

