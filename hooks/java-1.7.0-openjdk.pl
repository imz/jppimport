#!/usr/bin/perl -w

push @PREHOOKS, sub {
    my ($spec, $parent) = @_;
    my %type=map {$_=>1} qw/post postun pretrans posttrans/;
    # TODO: javadoc alternatives: not provided.
    # TODO: add proper alternatives to javadoc manually (and check java-1.7.0-oracle too!)
    my %pkg=map {$_=>1} '', 'devel', 'headless', 'javadoc';
    my @newsec=grep {not $type{$_->get_type()} or not $pkg{$_->get_raw_package()}} $spec->get_sections();
    $spec->set_sections(\@newsec);

};

sub __subst_systemtap {
    my ($section)=@_;
    my @newbody;
    my @oldbody=@{$section->get_bodyref()};
    my $i;
    for ($i=0; $i<@oldbody;$i++) {
	my $line=$oldbody[$i];
	if ($line=~/\%ifarch\s+\%\{jit_arches\}/ && (
		$i < $#oldbody &&
		$oldbody[$i+1]=~/systemtap|\.stp|tapset/) &&
	    $oldbody[$i+1]!~/Where to install systemtap tapset/) {
	    $line=~s/\%ifarch\s+\%\{jit_arches\}/\%if_enabled systemtap/g;
	}
	$line=~s/\%if\s+\%\{with_systemtap\}/\%if_enabled systemtap/g;
	push @newbody, $line;
    }
    $section->set_body(\@newbody);
}

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    my $mainsec=$spec->main_section;

    # jpp7
    $mainsec->unshift_body('%define with_systemtap 0'."\n");

    # man pages are used in alternatives
    $mainsec->unshift_body('%set_compress_method none'."\n");

    $spec->get_section('package','javadoc')->push_body('# fc provides
Provides: java-javadoc = 1:1.7.0
');

    # or BR: gcc4.9-c++ + %set_gcc_version 4.9
    $spec->add_patch(q!java-1.7.0-openjdk-gcc-cxx-5-5d0a13adec23.patch!, STRIP=>0);

    # https://bugzilla.altlinux.org/show_bug.cgi?id=27050
    #$mainsec->unshift_body('%add_verify_elf_skiplist *.debuginfo'."\n");
    $spec->get_section('prep')->push_body(q!sed -i -e 's,DEF_OBJCOPY=/usr/bin/objcopy,DEF_OBJCOPY=/usr/bin/NO-objcopy,' openjdk/hotspot/make/linux/makefiles/defs.make!."\n");

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

    $mainsec->unshift_body(q'BuildRequires: unzip gcc-c++ libstdc++-devel-static
BuildRequires: libXext-devel libXrender-devel libXcomposite-devel
BuildRequires: libfreetype-devel libkrb5-devel
BuildRequires(pre): browser-plugins-npapi-devel lsb-release
BuildRequires(pre): rpm-macros-java
BuildRequires: pkgconfig(gtk+-2.0)
');

    $mainsec->unshift_body(q'%def_enable accessibility
%def_disable jvmjardir
%def_disable javaws
%def_disable moz_plugin
%def_disable control_panel
%def_disable systemtap
%def_disable desktop
');
    $mainsec->push_body('
%define altname %name
%define label -%{name}
%define javaws_ver      %{javaver}

%def_without gcc49
%if_with gcc49
%set_gcc_version 4.9
BuildRequires: gcc4.9-c++
%endif
# gcc5? links in a strange way that generates additional requires :(
# findprov below did not help at all :(
%add_findprov_lib_path %{_jvmdir}/%{jredir}/lib/%archinstall
%add_findprov_lib_path %{_jvmdir}/%{jredir}/lib/%archinstall/jli
# it is needed for those apps which links with libjvm.so
%add_findprov_lib_path %{_jvmdir}/%{jredir}/lib/%archinstall/server
%ifnarch x86_64
%add_findprov_lib_path %{_jvmdir}/%{jredir}/lib/%archinstall/client
%endif

%ifarch x86_64
Provides: /usr/lib/jvm/java/jre/lib/%archinstall/server/libjvm.so()(64bit)
Provides: /usr/lib/jvm/java/jre/lib/%archinstall/server/libjvm.so(SUNWprivate_1.1)(64bit)
%endif
%ifarch %ix86
Provides: /usr/lib/jvm/java/jre/lib/%archinstall/server/libjvm.so()
Provides: /usr/lib/jvm/java/jre/lib/%archinstall/server/libjvm.so(SUNWprivate_1.1)
Provides: /usr/lib/jvm/java/jre/lib/%archinstall/client/libjvm.so()
Provides: /usr/lib/jvm/java/jre/lib/%archinstall/client/libjvm.so(SUNWprivate_1.1)
%endif
');
    $mainsec->unshift_body(q'# ALT arm fix by Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
%ifarch %{arm}
%set_verify_elf_method textrel=relaxed
%endif
');

    # TODO drop
    # parasyte -Werror breaks build on x86_64
    $spec->add_patch('java-1.7.0-openjdk-alt-no-Werror.patch',STRIP=>1);

#map {if ($_->get_type() eq 'package') {
#	$_->subst_body_if(qr'^Provides:','#Provides:','java-1.7.0-icedtea');
#	$_->subst_body_if(qr'^Obsoletes:','#Obsoletes:','java-1.7.0-icedtea');
# }
#} $spec->get_sections();
    
    # already 0
    #$mainsec->subst_body(qr'define runtests 1','define runtests 0');

    #$mainsec->subst_body(qr'^\%define _libdir','# define _libdir');
    #$mainsec->subst_body(qr'^\%define syslibdir','# define syslibdir');

    $mainsec=$spec->main_section;
    $mainsec->set_tag('Epoch','0') if $mainsec->match_body(qr'^Epoch:\s+[1-9]');

    my $headlsec=$spec->get_section('package','headless');
    $headlsec->exclude_body('^Requires: maven-local'."\n");
    $headlsec->push_body('Requires: java-common'."\n");
    $headlsec->push_body('Requires: /proc'."\n");
    $headlsec->push_body(q!Requires(post): /proc!."\n");

    # unrecognized option; TODO: check the list
    #$spec->get_section('build')->subst_body(qr'./configure','./configure --with-openjdk-home=/usr/lib/jvm/java');
    # DISTRO_PACKAGE_VERSION="fedora-...
    $spec->get_section('build')->subst_body(qr'fedora-','ALTLinux-');
    # DISTRO_NAME="Fedora"
    $spec->get_section('build')->subst_body(qr'"Fedora"','"ALTLinux"');

    ## TODO: check if it still valid
    # hack for sun-based build (i586) only!!!
    #$spec->get_section('build')->subst_body(qr'^\s*make','make MEMORY_LIMIT=-J-Xmx512m');

    $spec->get_section('install')->unshift_body('unset JAVA_HOME'."\n");

    # why do we need it?
    #$spec->get_section('install')->subst_body(qr'mv bin/java-rmi.cgi sample/rmi',':; #mv bin/java-rmi.cgi sample/rmi');

    # just to suppress warnings on %
    $spec->get_section('install')->subst_body_if(qr'\%dir','%%dir','sed');
    $spec->get_section('install')->subst_body_if(qr'\%doc','%%doc','sed');

    # TODO: fix caserts generation!!!
    # for proper symlink requires ? 
    $mainsec->unshift_body('BuildRequires: ca-certificates-java'."\n");

    # to disable --enable-systemtap
    #$mainsec->subst_body(qr'--enable-systemtap','%{subst_enable systemtap}');
    &__subst_systemtap($mainsec);
    &__subst_systemtap($spec->get_section('prep'));
    &__subst_systemtap($spec->get_section('install'));
    &__subst_systemtap($spec->get_section('files','devel'));

    # big changelog
    #$spec->get_section('files','')->subst_body(qr'^\%doc ChangeLog','#doc ChangeLog');

# --- alt linux specific, shared with openjdk ---#
    $spec->get_section('files','')->unshift_body('%_sysconfdir/buildreqs/packages/substitute.d/%name'."\n");
    $spec->get_section('files','headless')->unshift_body('%_altdir/%altname-java-headless
%_sysconfdir/buildreqs/packages/substitute.d/%name-headless'."\n");
    $spec->get_section('files','devel')->unshift_body('%_altdir/%altname-javac
%_sysconfdir/buildreqs/packages/substitute.d/%name-devel'."\n");
    $spec->_reset_speclist();
    $mainsec=$spec->main_section;

    $spec->get_section('install')->push_body(q!
sed -i 's,^Categories=.*,Categories=Settings;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};,' %buildroot/usr/share/applications/*policytool.desktop
sed -i 's,^Categories=.*,Categories=Development;Profiling;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};,' %buildroot/usr/share/applications/*jconsole.desktop
!);

    $spec->get_section('install')->push_body(q!
##### javadoc Alt specific #####
echo java-javadoc >java-javadoc-buildreq-substitute
mkdir -p %buildroot%_sysconfdir/buildreqs/packages/substitute.d
install -m644 java-javadoc-buildreq-substitute \
    %buildroot%_sysconfdir/buildreqs/packages/substitute.d/%name-javadoc
install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/%altname-javadoc<<EOF
%{_javadocdir}/java	%{_javadocdir}/%{uniquejavadocdir}/api	%{priority}
EOF
!);
    $spec->get_section('files','javadoc')->unshift_body('%_altdir/%altname-javadoc
%_sysconfdir/buildreqs/packages/substitute.d/%name-javadoc
');

    $spec->get_section('install')->push_body(q!# move soundfont to java
grep /audio/default.sf2 java-1.7.0-openjdk.files-headless >> java-1.7.0-openjdk.files
grep -v /audio/default.sf2 java-1.7.0-openjdk.files-headless > java-1.7.0-openjdk.files-headless-new
mv java-1.7.0-openjdk.files-headless-new java-1.7.0-openjdk.files-headless
!."\n");
    $spec->get_section('files','headless')->push_body(q!%exclude %{_jvmdir}/%{jredir}/lib/audio/default.sf2!."\n");

    # NOTE: s,sdklnk,sdkdir,g
    $spec->get_section('install')->push_body(q!

##################################################
# --- alt linux specific, shared with openjdk ---#
##################################################

install -d -m 755 $RPM_BUILD_ROOT%{_datadir}/applications
if [ -e $RPM_BUILD_ROOT%{_jvmdir}/%{sdkdir}/bin/jvisualvm ]; then
  cat >> $RPM_BUILD_ROOT%{_datadir}/applications/%{name}-jvisualvm.desktop << EOF
[Desktop Entry]
Name=Java VisualVM (%{name})
Comment=Java Virtual Machine Monitoring, Troubleshooting, and Profiling Tool
Exec=%{_jvmdir}/%{sdkdir}/bin/jvisualvm
Icon=%{name}
Terminal=false
Type=Application
Categories=Development;Profiling;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};
EOF
fi

%if_enabled control_panel
# ControlPanel freedesktop.org menu entry
cat >> $RPM_BUILD_ROOT%{_datadir}/applications/%{name}-control-panel.desktop << EOF
[Desktop Entry]
Name=Java Plugin Control Panel (%{name})
Comment=Java Control Panel
Exec=%{_jvmdir}/%{jredir}/bin/jcontrol
Icon=%{name}
Terminal=false
Type=Application
Categories=Settings;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};
EOF
%endif

%if_enabled javaws
# javaws freedesktop.org menu entry
cat >> $RPM_BUILD_ROOT%{_datadir}/applications/%{name}-javaws.desktop << EOF
[Desktop Entry]
Name=Java Web Start (%{name})
Comment=Java Application Launcher
MimeType=application/x-java-jnlp-file;
Exec=%{_jvmdir}/%{jredir}/bin/javaws %%u
Icon=%{name}
Terminal=false
Type=Application
Categories=Settings;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};
EOF
%endif

# Install substitute rules for buildreq
echo java >j2se-buildreq-substitute
echo java-headless >j2se-headless-buildreq-substitute
echo java-devel >j2se-devel-buildreq-substitute
mkdir -p %buildroot%_sysconfdir/buildreqs/packages/substitute.d
install -m644 j2se-buildreq-substitute \
    %buildroot%_sysconfdir/buildreqs/packages/substitute.d/%name
install -m644 j2se-headless-buildreq-substitute \
    %buildroot%_sysconfdir/buildreqs/packages/substitute.d/%name-headless
install -m644 j2se-devel-buildreq-substitute \
    %buildroot%_sysconfdir/buildreqs/packages/substitute.d/%name-devel

install -d %buildroot%_altdir

# J2SE alternative
cat <<EOF >%buildroot%_altdir/%name-java-headless
%{_bindir}/java	%{_jvmdir}/%{jredir}/bin/java	%priority
%_man1dir/java.1.gz	%_man1dir/java%{label}.1.gz	%{_jvmdir}/%{jredir}/bin/java
EOF
# binaries and manuals
for i in keytool policytool servertool pack200 unpack200 \
orbd rmid rmiregistry tnameserv
do
  cat <<EOF >>%buildroot%_altdir/%name-java-headless
%_bindir/$i	%{_jvmdir}/%{jredir}/bin/$i	%{_jvmdir}/%{jredir}/bin/java
%_man1dir/$i.1.gz	%_man1dir/${i}%{label}.1.gz	%{_jvmdir}/%{jredir}/bin/java
EOF
done

%if_enabled control_panel
cat <<EOF >>%buildroot%_altdir/%name-java
%{_bindir}/ControlPanel	%{_jvmdir}/%{jredir}/bin/ControlPanel	%{_jvmdir}/%{jredir}/bin/java
%{_bindir}/jcontrol	%{_jvmdir}/%{jredir}/bin/jcontrol	%{_jvmdir}/%{jredir}/bin/java
EOF
%endif
# ----- JPackage compatibility alternatives ------
cat <<EOF >>%buildroot%_altdir/%name-java-headless
%{_jvmdir}/jre	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmdir}/jre-%{origin}	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmdir}/jre-%{javaver}	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmdir}/jre-%{javaver}-%{origin}	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%if_enabled jvmjardir
%{_jvmjardir}/jre	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmjardir}/jre-%{origin}	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmjardir}/jre-%{javaver}	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%endif
EOF
# ----- end: JPackage compatibility alternatives ------


# Javac alternative
cat <<EOF >%buildroot%_altdir/%name-javac
%_bindir/javac	%{_jvmdir}/%{sdkdir}/bin/javac	%priority
%_man1dir/javac.1.gz	%_man1dir/javac%{label}.1.gz	%{_jvmdir}/%{sdkdir}/bin/javac
EOF

# binaries and manuals
for i in appletviewer extcheck idlj jar jarsigner javadoc javah javap jdb native2ascii rmic serialver apt jconsole jinfo jmap jmc jps jsadebugd jstack jstat jstatd \
jhat jrunscript jvisualvm schemagen wsgen wsimport xjc
do
  if [ -e $RPM_BUILD_ROOT%{_jvmdir}/%{sdkdir}/bin/$i ]; then
  cat <<EOF >>%buildroot%_altdir/%name-javac
%_bindir/$i	%{_jvmdir}/%{sdkdir}/bin/$i	%{_jvmdir}/%{sdkdir}/bin/javac
%_man1dir/$i.1.gz	%_man1dir/${i}%{label}.1.gz	%{_jvmdir}/%{sdkdir}/bin/javac
EOF
  fi
done
# binaries w/o manuals
for i in HtmlConverter
do
  cat <<EOF >>%buildroot%_altdir/%name-javac
%_bindir/$i	%{_jvmdir}/%{sdkdir}/bin/$i	%{_jvmdir}/%{sdkdir}/bin/javac
EOF
done

# ----- JPackage compatibility alternatives ------
  cat <<EOF >>%buildroot%_altdir/%name-javac
%{_jvmdir}/java	%{_jvmdir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmdir}/java-%{origin}	%{_jvmdir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmdir}/java-%{javaver}	%{_jvmdir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmdir}/java-%{javaver}-%{origin}	%{_jvmdir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%if_enabled jvmjardir
%{_jvmjardir}/java	%{_jvmjardir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmjardir}/java-%{origin}	%{_jvmjardir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmjardir}/java-%{javaver}	%{_jvmjardir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%endif
EOF

# ----- end: JPackage compatibility alternatives ------

# hack (see #11383) to enshure that all man pages will be compressed
for i in $RPM_BUILD_ROOT%_man1dir/*.1; do
    [ -f $i ] && gzip -9 $i
done

##################################################
# - END alt linux specific, shared with openjdk -#
##################################################


echo "install passed past alt linux specific."
!);

    #$spec->_reset_speclist();

    $spec->add_section('post','headless')->push_body(q@# java should be available ASAP
%force_update_alternatives

%ifarch %{jit_arches}
# MetaspaceShared::generate_vtable_methods not implemented for PPC JIT
%ifnarch %{power64}
#see https://bugzilla.redhat.com/show_bug.cgi?id=513605
java=%{jrebindir}/java
if [ -f /proc/cpuinfo ] && ! [ -d /.ours ] ; then #real workstation; not a mkimage-profile, etc
    $java -Xshare:dump >/dev/null 2>/dev/null
fi
%endif
%endif
@);

    #### Misterious bug:
    # java -version work with JAVA_HOME=/usr/lib/jvm/java-1.7.0
    # but does not work with JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk
    # both are alternatives, former one works, but later one somehow is broken :(
    $spec->get_section('build')->subst_body_if(qr/\.0-openjdk/,'.0',qr!JDK_TO_BUILD_WITH=/usr/lib/jvm/java-1.[789].0-openjdk!);

#error: writeable files in /usr: /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.79-2.5.5.0.x86_64/jre/lib/amd64/server/classes.jsa
#error: writeable files in /usr: /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.79-2.5.5.0.x86_64/jre/lib/amd64/client/classes.jsa
#%attr(664, root, root) %ghost %{_jvmdir}/%{jredir}/lib/%{archinstall}/server/classes.jsa
#%attr(664, root, root) %ghost %{_jvmdir}/%{jredir}/lib/%{archinstall}/client/classes.jsa
    $spec->get_section('files','headless')->subst_body_if(qr/664,/,'644,',qr!classes.jsa!);


    #ppc support
    $spec->get_section('package','devel')->push_body('
# hack for missing java 1.5.0 on ppc
%ifarch ppc ppc64
Provides: java-devel = 1.5.0
%endif
') if 0; # jdk 1.6 already provides

    $spec->get_section('package','')->subst_body(qr'^BuildRequires: libat-spi-devel','#BuildRequires: libat-spi-devel');
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

};


__END__
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
