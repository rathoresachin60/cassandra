#!/bin/bash
nodetool -u rsacassandra -pw XCyota01! garbagecollect -- $1 $2
nodetool -u rsacassandra -pw XCyota01! garbagecollect -- $1 $2
nodetool -u rsacassandra -pw XCyota01! compact -s -- $1 $2

