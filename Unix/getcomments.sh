#!/bin/bash

grep -E -o '#.+$' $1 # look for pattern starting with # (commentary symbol) followed by any character repeated once or more and finishing at the end of the line '$'