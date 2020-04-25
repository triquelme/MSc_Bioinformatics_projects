#!/bin/bash

cat -n < $1 | # show line number before line
sort -n -r -k 1 | # sort numerically accoding to column 1 (line number) and reverse it
cut -f 2- # cut line numbers, show only lines'content (column 2 and next)

