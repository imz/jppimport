#!/usr/bin/perl -w

#see https://developers.redhat.com/blog/2018/11/05/migrating-from-oracle-jdk-to-openjdk-on-red-hat-enterprise-linux-what-you-need-to-know/

my $centos=1;
require 'set_jvm_preprocess.pl';
require 'java-openjdk-common.pl';
$__jre::dir='%{jredir}';
require 'java-openjdk-common-jobs-parallel.pl';

# https://bugzilla.redhat.com/show_bug.cgi?id=787513
#alternatives.prov: /usr/src/tmp/java-1.6.0-openjdk-buildroot/etc/alternatives/packages.d/java-1.6.0-openjdk-java: /usr/share/man/man1/policytool-java-1.6.0-openjdk.1.gz for /usr/share/man/man1/policytool.1.gz is in another subpackage

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    my $mainsec=$spec->main_section;

# TODO: current hack:
# 1) drop custom optflags?
# 2) add
#sed -i -e 's, -m32, -m32 %optflags_shared -fpic -D_BLA_BLA_BLA1,' openjdk/hotspot/make/linux/makefiles/gcc.make
    # fix textrels on %ix86
    $spec->get_section('prep')->push_body(q!sed -i -e 's, -m32, -m32 %optflags_shared -fpic -D_BLA_BLA_BLA1,' openjdk/hotspot/make/linux/makefiles/gcc.make!."\n");

    # for %{__global_ldflags} -- might be dropped in the future
    $mainsec->unshift_body('BuildRequires(pre): rpm-macros-fedora-compat'."\n");

    # built!
    #$mainsec->subst_body_if(qr'1','0',qr'^\%global\s+with_openjfx_binding');

    # no debug build in 1.8.65
    $mainsec->subst_body(qr'^\%global include_debug_build 1','%global include_debug_build 0');

    # https://bugzilla.altlinux.org/show_bug.cgi?id=27050
    #$mainsec->unshift_body('%add_verify_elf_skiplist *.debuginfo'."\n");
    $spec->get_section('prep')->push_body(q!sed -i -e 's,DEF_OBJCOPY=/usr/bin/objcopy,DEF_OBJCOPY=/usr/bin/NO-objcopy,' openjdk/hotspot/make/linux/makefiles/defs.make!."\n");

    $spec->get_section('package','javadoc')->push_body('# fc provides
Provides: java-javadoc = 1:1.9.0
');

    $mainsec->exclude_body(qr'^Obsoletes:\s+(?:java-1.7.0-openjdk)');

    # TODO drop
    # parasyte -Werror breaks build on x86_64
    $spec->add_patch('java-1.8.0-openjdk-alt-no-Werror.patch',STRIP=>1);

    # as-needed link order / better patch over patch system-libjpeg.patch ?
    $spec->add_patch('java-1.8.0-openjdk-alt-link.patch',STRIP=>1);
    $spec->spec_apply_patch(PATCHFILE=>'java-1.8.0-openjdk-alt-bug-32463.spec.diff') if not $centos;

    # already 0
    #$mainsec->subst_body(qr'define runtests 1','define runtests 0');

    # unrecognized option; TODO: check the list
    #$spec->get_section('build')->subst_body(qr'./configure','./configure --with-openjdk-home=/usr/lib/jvm/java');

    # do we need it?
    $spec->get_section('install')->unshift_body('unset JAVA_HOME'."\n");

    #### Misterious bug:
    # java -version work with JAVA_HOME=/usr/lib/jvm/java-1.7.0
    # but does not work with JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk
    # both are alternatives, former one works, but later one somehow is broken :(
    $spec->get_section('build')->subst_body_if(qr/\.0-openjdk/,'.0',qr!JDK_TO_BUILD_WITH=/usr/lib/jvm/java-1.[789].0-openjdk!);

};


__END__
    # i586 build is not included :(
    #$mainsec->subst_body(qr'ifarch i386','ifarch %ix86');
    #$mainsec->subst_body_if(qr'i686','%ix86',qr'^ExclusiveArch:');

    $spec->spec_apply_patch(PATCHSTRING=> q!
--- java-1.7.0-openjdk.spec	2012-04-16 23:15:27.000000000 +0300
+++ java-1.7.0-openjdk.spec	2012-04-16 23:17:56.000000000 +0300
@@ -869,6 +869,7 @@
 popd
 %endif
 
+%if_with java_access_bridge
 # Build Java Access Bridge for GNOME.
 pushd java-access-bridge-%{accessver}
   patch -l -p1 < %{PATCH1}
@@ -881,6 +882,7 @@
   cp -a bridge/accessibility.properties $JAVA_HOME/jre/lib
   cp -a gnome-java-bridge.jar $JAVA_HOME/jre/lib/ext
 popd
+%endif
 
 # Copy tz.properties
 echo "sun.zoneinfo.dir=/usr/share/javazi" >> $JAVA_HOME/jre/lib/tz.properties
!) if 0;

    # no more;
    #$mainsec->subst_body_if(qr'java-1.8.0-openjdk','java-1.7.0-openjdk',qr'^BuildRequires:');

    ## TODO: check if it still valid
    # hack for sun-based build (i586) only!!!
    #$spec->get_section('build')->subst_body(qr'^\s*make','make MEMORY_LIMIT=-J-Xmx512m');
    # why do we need it?
    #$spec->get_section('install')->subst_body(qr'mv bin/java-rmi.cgi sample/rmi',':; #mv bin/java-rmi.cgi sample/rmi');
    $spec->get_section('install')->push_body(q!# move soundfont to java
grep /audio/default.sf2 java-1.8.0-openjdk.files-headless >> java-1.8.0-openjdk.files
grep -v /audio/default.sf2 java-1.8.0-openjdk.files-headless > java-1.8.0-openjdk.files-headless-new
mv java-1.8.0-openjdk.files-headless-new java-1.8.0-openjdk.files-headless
!."\n");
    $spec->get_section('files','headless')->push_body(q!%exclude %{_jvmdir}/%{jredir}/lib/audio/default.sf2!."\n");

    # builds end up randomly :(
    $spec->get_section('build')->subst_body(qr'kill -9 `cat Xvfb.pid`','kill -9 `cat Xvfb.pid` || :');

    # chrpath hack (disabled)
    if (0) {
	$mainsec->push_body(q'# hack :(
BuildRequires: chrpath
# todo: remove after as-needed fix
%set_verify_elf_method unresolved=relaxed
');
	$spec->get_section('install')->push_body(q!
# chrpath hack :(
find $RPM_BUILD_ROOT -name '*.so' -exec chrpath -d {} \;
find $RPM_BUILD_ROOT/%{sdkbindir}/ -exec chrpath -d {} \;
find $RPM_BUILD_ROOT/%{_jvmdir}/%{jredir}/bin/ -exec chrpath -d {} \;
!);
    }
    # end chrpath hack

    $spec->get_section('install')->push_body(q!
# HACK around find-requires
%define __find_requires    $RPM_BUILD_ROOT/.find-requires
cat > $RPM_BUILD_ROOT/.find-requires <<EOF
(/usr/lib/rpm/find-requires | grep -v %{_jvmdir}/%{sdkdir} | grep -v /usr/bin/java | sed -e s,^/usr/lib64/lib,lib, | sed -e s,^/usr/lib/lib,lib,) || :
EOF
chmod 755 $RPM_BUILD_ROOT/.find-requires
# end HACK around find-requires
!);
