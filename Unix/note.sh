#!/bin/bash

num_etu="`grep $1 num-nom.txt | # look for a name contained in $1 (given in parameter to the script) inside "num-nom.txt" file
cut -d ' ' -f 1`" # then keep only the first column in the line resulting (means keeping the student number and discarding the name)
				  # and store the result of the command (=student number) inside varibale 'num_etu'
#or
#num_etu="$(grep $1 num-nom.txt |
#cut -d ' ' -f 1)"

echo "num etu:" $num_etu # print student number to show to the user
#grep $num_etu num-note.txt
echo "note:" $(grep $num_etu num-note.txt | # then  look in the other file "num-note.txt" the corresponding grade to this student number
cut -d ' ' -f 2)
