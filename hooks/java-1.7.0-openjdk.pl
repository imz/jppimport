#!/usr/bin/perl -w

require 'java-openjdk-common.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    my $mainsec=$spec->main_section;

    # jpp7
    $mainsec->unshift_body('%define with_systemtap 0'."\n");

    $spec->get_section('package','javadoc')->push_body('# fc provides
Provides: java-javadoc = 1:1.7.0
');

    # i586 build is not included :(
    #$mainsec->subst_body(qr'ifarch i386','ifarch %ix86');
    #$mainsec->subst_body_if(qr'i686','%ix86',qr'^ExclusiveArch:');

$spec->spec_apply_patch(PATCHSTRING=>q!
 # Hard-code libdir on 64-bit architectures to make the 64-bit JDK
 # simply be another alternative.
--- java-1.7.0-openjdk-1.7.0.1-alt1_2.0.3jpp6/java-1.7.0-openjdk.spec   2012-02-
12 17:57:37.000000000 +0000
+++ java-1.7.0-openjdk-1.7.0.1-alt1_2.0.3jpp6/java-1.7.0-openjdk.spec   2012-02-12 17:22:40.000000000 +0000
@@ -110,8 +110,7 @@ # simply be another alternative.
 %global LIBDIR       %{_libdir}
 #backuped original one
 %ifarch %{multilib_arches}
-%global syslibdir       %{_prefix}/lib64
-%global _libdir         %{_prefix}/lib
+%global syslibdir       %{_libdir}
 %else
 %global syslibdir       %{_libdir}
 %endif
!);
$spec->spec_apply_patch(PATCHSTRING=>q!
# fix definitions for rpm 4.0.4
--- java-1.7.0-openjdk.spec	2014-07-05 16:37:23.000000000 +0300
+++ java-1.7.0-openjdk.spec	2014-07-05 16:47:31.000000000 +0300
@@ -124,6 +123,10 @@
 %global priority        1700%{updatever}
 %global javaver         1.7.0
 
+%global fullversion     %{name}-%{version}-%{release}
+
+%global uniquesuffix          %{fullversion}.%{_arch}
+
 %global sdkdir          %{uniquesuffix}
 %global jrelnk          jre-%{javaver}-%{origin}-%{version}-%{release}.%{_arch}
 
@@ -132,9 +135,6 @@
 %global jrebindir       %{_jvmdir}/%{jredir}/bin
 %global jvmjardir       %{_jvmjardir}/%{uniquesuffix}
 
-%global fullversion     %{name}-%{version}-%{release}
-
-%global uniquesuffix          %{fullversion}.%{_arch}
 #we can copy the javadoc to not arched dir, or made it not noarch
 %global uniquejavadocdir       %{fullversion}
 

!);

    $mainsec=$spec->main_section;
    $mainsec->exclude_body(qr'^Obsoletes:\s+java-1.6.0-openjdk');
    $mainsec->subst_body(qr'^BuildRequires:\s+ant','BuildRequires: ant1.9');
    $spec->add_source(FILE=>'rhino.jar');
    $spec->get_section('build')->map_body(sub{
	s,/usr/bin/ant,/usr/bin/ant1.9,;
	s,/usr/share/java/rhino.jar,\%_sourcedir/rhino.jar,;
    });

    # TODO drop
    # parasyte -Werror breaks build on x86_64
    $spec->add_patch('java-1.7.0-openjdk-alt-no-Werror.patch',STRIP=>1);

    # already 0
    #$mainsec->subst_body(qr'define runtests 1','define runtests 0');

    # do we need it?
    $spec->get_section('install')->unshift_body('unset JAVA_HOME'."\n");

    #### Misterious bug:
    # java -version work with JAVA_HOME=/usr/lib/jvm/java-1.7.0
    # but does not work with JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk
    # both are alternatives, former one works, but later one somehow is broken :(
    $spec->get_section('build')->subst_body_if(qr/\.0-openjdk/,'.0',qr!JDK_TO_BUILD_WITH=/usr/lib/jvm/java-1.[789].0-openjdk!);

    $spec->get_section('package','')->subst_body(qr'^BuildRequires: at-spi-devel','#BuildRequires: at-spi-devel');

    $spec->spec_apply_patch(PATCHSTRING=>q!
--- java-1.7.0-openjdk.spec	2018-06-03 13:33:01.396821267 +0300
+++ java-1.7.0-openjdk.spec	2018-06-03 13:34:16.086115317 +0300
@@ -825,7 +825,7 @@
   STRIP_POLICY="no_strip" \
   JAVAC_WARNINGS_FATAL="false" \
   INSTALL_LOCATION=%{_jvmdir}/%{sdkdir} \
-  SYSTEM_NSS="true" \
+  SYSTEM_NSS="" \
   NSS_LIBS="%{NSS_LIBS} -lfreebl" \
   NSS_CFLAGS="%{NSS_CFLAGS}" \
   ECC_JUST_SUITE_B="true" \
@@ -869,7 +869,7 @@
   STRIP_POLICY="no_strip" \
   JAVAC_WARNINGS_FATAL="false" \
   INSTALL_LOCATION=%{_jvmdir}/%{sdkdir} \
-  SYSTEM_NSS="true" \
+  SYSTEM_NSS="" \
   NSS_LIBS="%{NSS_LIBS} -lfreebl" \
   NSS_CFLAGS="%{NSS_CFLAGS}" \
   ECC_JUST_SUITE_B="true" \
!);


};

__END__
