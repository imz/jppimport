#!/bin/sh
changelog='- update to new release by jppimport'
strategy=destup
[ -n "$1" ] && strategy=$1

jppmass --strategy $strategy --changelog "$changelog" --origin /var/ftp/pub/Linux/fedora/linux/development/rawhide/Everything/source/tree/Packages `cat import/fc/java.list`
