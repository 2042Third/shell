#!/bin/bash
path=/foo/bar/bim/baz/file.gif

file=${path%/*}  
echo $file