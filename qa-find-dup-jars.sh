egrep '/usr/share/java/.+.jar' /var/ftp/pub/Linux/ALT/Sisyphus/noarch/base/contents_index  | awk '{print $2}' | grep / | tee dup-jars.list
#for i in *.rpm; do if rpmquery -lp $i | fgrep -f ~/dup-jars.list ; then echo $i; fi; done
