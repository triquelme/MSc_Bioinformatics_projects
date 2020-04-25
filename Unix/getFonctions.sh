#!/bin/bash

grep -o 'def.*:' $1 # look for pattern starting with 'def', then containing any character repeated 0 times or more and finishing with ':'
# look inside the file given in parameter contained inside variable 1