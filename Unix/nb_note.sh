#!/bin/bash

#echo $1

#grep ' '$1 num-note.txt
#grep -c ' '$1 num-note.txt

cut -d ' ' -f 2 num-note.txt| # cut (means keep only) column 2 (-f), using space as separator for columns (-d) in num-note.txt file
grep -c $1 # and look for variable 1 in this results (column)
