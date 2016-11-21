#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;

    # Mikhail Efremov to Igor
    # Hello!
    # У меня в бранче sem есть исправления: исправлен предыдущий патч
    # (requests все-таки нужен), еще один патч и изменения в спеке.
    # С этими исправлениями (и исправленным jss) у меня оно вроде заработало с
    # freeipa: при установке выписались сертификаты.
    $spec->add_patch('pki-core-alt-local-urllib3.patch',STRIP=>1);
    $spec->add_patch('pki-core-alt-fix-paths.patch',STRIP=>1);
    $spec->get_section('package','')->unshift_body('BuildRequires: sh4'."\n");
    $spec->get_section('prep')->push_body(q{# from sem@:
# At least one script required bash4.
# Just use sh4 for all scripts.
egrep -rH '^#!/bin/(sh|bash)' . | cut -f1 -d: | sort -u | \
	xargs sed -r -i 's;^#!/bin/(sh|bash)( -X)?;#!/bin/sh4;'
});
    $spec->get_section('install')->push_body(q!# from sem@:
# This file should be sourced only
chmod -x %buildroot%_datadir/pki/scripts/operations
!);

    $spec->get_section('pretrans','-n pki-base')->delete;
    $spec->get_section('files','-n pki-base')->push_body('%dir %{_datadir}/pki/key'."\n");
    foreach my $pkg (qw/pki-base pki-server/) {
	$spec->get_section('post','-n '.$pkg)->subst_body(qr'(^|\s)/sbin/',' /usr/sbin/');
    }
    $spec->get_section('build')->unshift_body(q!
# ugly hacks for ALTLinux; fix me
# part 1: nss hacks
%add_optflags -I/usr/include/nss
sed -i -e 's,"nss3/base64.h","nss/base64.h",' \
	base/tps-client/src/modules/tokendb/mod_tokendb.cpp
# part 2: httpd/ -> apache2/
%add_optflags -I/usr/include/apu-1
sed -i -e 's,"httpd/httpd.h","apache2/httpd.h",' \
	base/tps-client/src/engine/RA.cpp \
	base/tps-client/stubs/modules/nss/mod_nss_stub.c \
	base/tps-client/src/modules/tps/mod_tps.cpp \
	base/tps-client/src/modules/tps/AP_Session.cpp \
	base/tps-client/src/modules/tps/AP_Context.cpp \
	base/tps-client/src/modules/tokendb/mod_tokendb.cpp \
	base/tps-client/src/engine/RA.cpp
sed -i -e 's,"httpd/http_config.h","apache2/http_config.h",' \
	base/tps-client/stubs/modules/nss/mod_nss_stub.c \
	base/tps-client/src/modules/tps/mod_tps.cpp \
	base/tps-client/src/modules/tokendb/mod_tokendb.cpp
sed -i -e 's,include "httpd/http_,include "apache2/http_,' \
	base/tps-client/stubs/modules/nss/mod_nss_stub.c \
	base/tps-client/src/modules/tps/AP_Context.cpp \
	base/tps-client/src/modules/tps/AP_Session.cpp \
	base/tps-client/src/modules/tps/mod_tps.cpp \
	base/tps-client/src/modules/tokendb/mod_tokendb.cpp
# end ugly hacks
!);
};

__END__
--- pki-core.spec.orig	2016-04-29 21:18:19.047650940 +0300
+++ pki-core.spec	2016-04-29 23:04:50.666220799 +0300
@@ -116,7 +116,8 @@
 BuildRequires:    python-module-selinux
 BuildRequires: policycoreutils python-module-sepolgen
 %if 0%{?fedora} >= 23
-BuildRequires:    policycoreutils-python-utils
+#BuildRequires:    policycoreutils-python-utils
+BuildRequires:    policycoreutils-gui policycoreutils-devel
 %endif
 BuildRequires:    python-module-ldap
 BuildRequires:    junit
@@ -455,11 +456,11 @@
 Requires:         pki-tools = %{version}
 Requires: policycoreutils python-module-sepolgen
 %if 0%{?fedora} >= 23
-Requires:         policycoreutils-python-utils
+#Requires:         policycoreutils-python-utils
 %endif
 
 %if 0%{?fedora} >= 21
-Requires:         selinux-policy-targeted >= 3.13.1
+#Requires:         selinux-policy-targeted >= 3.13.1
 %else
 # 0%{?rhel} || 0%{?fedora} < 21
 Requires:         selinux-policy-targeted >= 3.12.1
@@ -801,11 +832,11 @@
 
 %if ! 0%{?rhel}
 # Scanning the python code with pylint.
-sh ../pylint-build-scan.sh %{buildroot} `pwd`
-if [ $? -ne 0 ]; then
-    echo "pylint failed. RC: $?"
-    exit 1
-fi
+#sh ../pylint-build-scan.sh %{buildroot} `pwd`
+#if [ $? -ne 0 ]; then
+#    echo "pylint failed. RC: $?"
+#    exit 1
+#fi
 %endif
 
 %{__rm} -rf %{buildroot}%{_datadir}/pki/server/lib
