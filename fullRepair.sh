#!/bin/bash
nodetool -u rsacassandra -pw ****** repair -pr -- $1 $2

