#!/bin/sh

#tmp=./classes
#mkdir $tmp
tmp=`mktemp -d` || exit 1
unzip -d $tmp $1 >/dev/null
find $tmp -name '*.class' -exec file -b {} \; | sort -u
rm -rf $tmp


#-target 1.1: 45.3
#-target 1.2: 46.0
#-target 1.3: 47.0
#-target 1.4: 48.0
#-target 1.5: 49.0
