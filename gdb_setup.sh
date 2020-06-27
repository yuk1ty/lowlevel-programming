#!/bin/bash

touch ~/.gdbinit
echo "set auto-load safe-path /" >> ~/.gdbinit
echo "set disassembly-flavor intel" >> ~/.gdbinit