#!/bin/sh

print_rpm_jarinfo()
{
    local rpm="$1"
    tmp=`mktemp -d` || exit 1
    mkdir -p $tmp/unpack
    curdir=`pwd`
    [ ${rpm:0:1} = "/" ] || rpm="$curdir/$rpm"
    pushd $tmp/unpack >/dev/null
    rpm2cpio "$rpm" | pax -O -r
    popd >/dev/null
    find $tmp/unpack/usr -type f -name '*.jar' | while read a; do
	mkdir -p $tmp/jar
	unzip -d $tmp/jar "$a" >/dev/null
	find $tmp/jar -name '*.class' -exec file -b {} \; | sort -u >> $tmp/ver
	rm -rf $tmp/jar
    done
    echo "javaclassinfo: $1:"
    sort -u $tmp/ver
    rm -rf $tmp
}

for i in "$@"; do
    print_rpm_jarinfo "$i"
done

#-target 1.1: 45.3
#-target 1.2: 46.0
#-target 1.3: 47.0
#-target 1.4: 48.0
#-target 1.5: 49.0
#-target 1.6: 50.0
#-target 1.7: 51.0
