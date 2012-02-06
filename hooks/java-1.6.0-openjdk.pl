#!/usr/bin/perl -w

# https://bugzilla.redhat.com/show_bug.cgi?id=787513
#alternatives.prov: /usr/src/tmp/java-1.6.0-openjdk-buildroot/etc/alternatives/packages.d/java-1.6.0-openjdk-java: /usr/share/man/man1/policytool-java-1.6.0-openjdk.1.gz for /usr/share/man/man1/policytool.1.gz is in another subpackage

# MADE optional, but what to replace?
#alternatives.prov: /usr/src/tmp/java-1.6.0-openjdk-buildroot/etc/alternatives/packages.d/java-1.6.0-openjdk-java: /usr/lib/jvm-private/java-1.6.0-openjdk/jce/vanilla/local_policy.jar for /usr/lib/jvm/jre-1.6.0-openjdk.x86_64/lib/security/local_policy.jar not found under RPM_BUILD_ROOT
#alternatives.prov: /usr/src/tmp/java-1.6.0-openjdk-buildroot/etc/alternatives/packages.d/java-1.6.0-openjdk-java: /usr/lib/jvm-private/java-1.6.0-openjdk/jce/vanilla/US_export_policy.jar for /usr/lib/jvm/jre-1.6.0-openjdk.x86_64/lib/security/US_export_policy.jar not found under RPM_BUILD_ROOT

    # NOTABUG, The Right Thing To DO.
#alternatives.prov: /usr/src/tmp/java-1.6.0-openjdk-buildroot/etc/alternatives/packages.d/java-1.6.0-openjdk-java: /usr/lib/jvm/jre-1.6.0-openjdk.x86_64/bin/java for /usr/bin/java is in another subpackage
#symlinks.req: WARNING: /usr/src/tmp/java-1.6.0-openjdk-buildroot/usr/lib/jvm/java-1.6.0-openjdk.x86_64: directory /usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64 not owned by the package

push @PREHOOKS, sub {
    my ($jpp, $alt) = @_;
    my %type=map {$_=>1} qw/post postun/;
    my %pkg=map {$_=>1} '', 'devel','plugin';
    my @newsec=grep {not $type{$_->get_type()} or not $pkg{$_->get_raw_package()}} $jpp->get_sections();
    $jpp->set_sections(\@newsec);
};

sub __subst_systemtap {
    my ($section)=@_;
    my @newbody;
    my @oldbody=@{$section->get_bodyref()};
    my $i;
    for ($i=0; $i<@oldbody;$i++) {
	my $line=$oldbody[$i];
	if ($line=~/\%ifarch\s+\%{jit_arches}/ && (
		$i < $#oldbody &&
		$oldbody[$i+1]=~/systemtap|\.stp|tapset/) &&
	    $oldbody[$i+1]!~/Where to install systemtap tapset/) {
	    $line=~s/\%ifarch\s+\%{jit_arches}/\%if_enabled systemtap/g;
	}
	push @newbody, $line;
    }
    $section->set_body(\@newbody);
}

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    my $mainsec=$jpp->main_section;

    # man pages are used in alternatives
    $mainsec->unshift_body('%set_compress_method none'."\n");

    # hack until RPM::Source::Convert will be enhanced
    $jpp->del_section('post','javadoc');
    $jpp->del_section('postun','javadoc');

    # Sisyphus unmet
    $mainsec->subst(qr'Requires: libjpeg = 6b','#Requires: libjpeg = 6b');

    $mainsec->unshift_body(q'BuildRequires: gcc-c++ libstdc++-devel-static 
BuildRequires: libXext-devel libXrender-devel
BuildRequires(pre): browser-plugins-npapi-devel
BuildRequires(pre): rpm-build-java
');

    $mainsec->unshift_body(q'%def_enable accessibility
%def_disable javaws
%def_disable moz_plugin
%def_disable systemtap
%def_disable desktop
');
    $mainsec->push_body('#define mozilla_java_plugin_so %{_jvmdir}/%{jrelnk}/lib/%{archinstall}/gcjwebplugin.so
%define mozilla_java_plugin_so %{_jvmdir}/%{jrelnk}/lib/%{archinstall}/IcedTeaPlugin.so
%define altname %name
%define label -%{name}
%define javaws_ver      %{javaver}

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

    map {if ($_->get_type() eq 'package') {
	$_->subst_if(qr'^Provides:','#Provides:','java-1.7.0-icedtea');
	$_->subst_if(qr'^Obsoletes:','#Obsoletes:','java-1.7.0-icedtea');
	 }
    } $jpp->get_sections();
    
    # already 0
    #$mainsec->subst(qr'define runtests 1','define runtests 0');

    $mainsec->subst(qr'^\%define _libdir','# define _libdir');
    $mainsec->subst(qr'^\%define syslibdir','# define syslibdir');
    $mainsec->push_body('Requires: java-common'."\n");
    $mainsec->push_body('Requires: /proc'."\n");

    # for M40; can(should?) be disabled on M41
    #$mainsec->subst(qr'lesstif-devel','openmotif-devel');
    $mainsec->subst(qr'java-1.5.0-gcj-devel','java-1.6.0-sun-devel');
    #$mainsec->subst(qr'java-1.6.0-openjdk-devel','java-1.6.0-sun-devel');
    $jpp->get_section('build')->unshift_body(q!unset JAVA_HOME
%autoreconf!."\n");
    #$jpp->get_section('build')->unshift_body(q!sed -i 's,libxul-unstable,libxul,g' configure.ac!."\n");
    $mainsec->set_tag('Epoch','0') if $mainsec->match_body(qr'^Epoch:\s+[1-9]');

    # unrecognized option; TODO: check the list
    #$jpp->get_section('build')->subst(qr'./configure','./configure --with-openjdk-home=/usr/lib/jvm/java');
    $jpp->get_section('build')->subst(qr'fedora-','ALTLinux-');

    # hack for sun-based build (i586) only!!!
    $jpp->get_section('build')->subst(qr'^\s*make','make MEMORY_LIMIT=-J-Xmx512m');
    # builds end up randomly :(
    $jpp->get_section('build')->subst(qr'kill -9 `cat Xvfb.pid`','kill -9 `cat Xvfb.pid` || :');

    $jpp->get_section('install')->unshift_body('unset JAVA_HOME'."\n");
    $jpp->get_section('install')->subst(qr'mv bin/java-rmi.cgi sample/rmi','#mv bin/java-rmi.cgi sample/rmi');
    # just to suppress warnings on %
    $jpp->get_section('install')->subst_if(qr'\%dir','%%dir','sed');
    $jpp->get_section('install')->subst_if(qr'\%doc','%%doc','sed');

    # TODO: fix caserts generation!!!
    # for proper symlink requires ? 
    $mainsec->unshift_body('BuildRequires: ca-certificates-java'."\n");

    $jpp->get_section('install')->subst_if(qr'--vendor=fedora','', qr'desktop-file-install');

    # to disable --enable-systemtap
    $mainsec->subst(qr'--enable-systemtap','%{subst_enable systemtap}');
    &__subst_systemtap($mainsec);
    &__subst_systemtap($jpp->get_section('install'));
    &__subst_systemtap($jpp->get_section('files','devel'));

    # big changelog
    $jpp->get_section('files','')->subst(qr'^\%doc ChangeLog','#doc ChangeLog');

# --- alt linux specific, shared with openjdk ---#

    if (0 and 'has plugin') {
	$jpp->get_section('package','plugin')->subst_if(qr'mozilla-filesystem','browser-plugins-npapi',qr'^Requires:');
	$jpp->rename_package('plugin','-n mozilla-plugin-%name');
	$jpp->get_section('files','-n mozilla-plugin-%name')->unshift_body('%_altdir/%altname-mozilla
%{_datadir}/applications/%{name}-control-panel.desktop
');
    }

    if (0 and 'javaws') {
	$jpp->get_section('package','devel')->push_body(q!
%if_enabled javaws
%package javaws
Summary: Java Web Start
Group: Networking/Other
Requires: %name = %version-%release
Requires(post,preun): alternatives
# --- jpackage compatibility stuff starts here ---
Provides:       javaws = %{epoch}:%{javaws_ver}
Obsoletes:      javaws-menu
# --- jpackage compatibility stuff ends here ---

%description javaws
Java Web Start is a deployment solution for Java-technology-based
applications. It is the plumbing between the computer and the Internet
that allows the user to launch and manage applications right off the
Web. Java Web Start provides easy, one-click activation of
applications, and guarantees that you are always running the latest
version of the application, eliminating complicated installation or
upgrade procedures.

This package provides the Java Web Start installation that is bundled
with %{name} J2SE Runtime Environment.
%endif # enabled javaws
!);
	$jpp->add_section('files','javaws');
	$jpp->get_section('files','javaws')->unshift_body('%_altdir/%altname-javaws
%{_datadir}/applications/%{name}-javaws.desktop
');
    }

    $jpp->get_section('files','')->unshift_body('%_altdir/%altname-java
%_sysconfdir/buildreqs/packages/substitute.d/%name
');
    $jpp->get_section('files','devel')->unshift_body('%_altdir/%altname-javac
%_sysconfdir/buildreqs/packages/substitute.d/%name-devel
');
    $jpp->_reset_speclist();

    $jpp->get_section('install')->push_body(q!
%__subst 's,^Categories=.*,Categories=Settings;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};,' %buildroot/usr/share/applications/policytool.desktop
%__subst 's,^Categories=.*,Categories=Development;Profiling;System;Monitor;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};,' %buildroot/usr/share/applications/jconsole.desktop
!);

    $jpp->get_section('install')->push_body(q!
# HACK around find-requires
%define __find_requires    $RPM_BUILD_ROOT/.find-requires
cat > $RPM_BUILD_ROOT/.find-requires <<EOF
(/usr/lib/rpm/find-requires | grep -v %{_jvmdir}/%{sdkdir} | grep -v /usr/bin/java | sed -e s,^/usr/lib64/lib,lib, | sed -e s,^/usr/lib/lib,lib,) || :
EOF
chmod 755 $RPM_BUILD_ROOT/.find-requires
# end HACK around find-requires

##################################################
# --- alt linux specific, shared with openjdk ---#
##################################################

install -d -m 755 $RPM_BUILD_ROOT%{_datadir}/applications
if [ -e $RPM_BUILD_ROOT%{_jvmdir}/%{sdkdir}/bin/jvisualvm ]; then
  cat >> $RPM_BUILD_ROOT%{_datadir}/applications/%{name}-jvisualvm.desktop << EOF
[Desktop Entry]
Name=Java VisualVM (%{name})
Comment=Java Virtual Machine Monitoring, Troubleshooting, and Profiling Tool
Exec=jvisualvm
Icon=%{name}
Terminal=false
Type=Application
Categories=Development;Profiling;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};
EOF
fi

%if_enabled moz_plugin
# ControlPanel freedesktop.org menu entry
cat >> $RPM_BUILD_ROOT%{_datadir}/applications/%{name}-control-panel.desktop << EOF
[Desktop Entry]
Name=Java Plugin Control Panel (%{name})
Comment=Java Control Panel
Exec=jcontrol
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
echo java-devel >j2se-devel-buildreq-substitute
mkdir -p %buildroot%_sysconfdir/buildreqs/packages/substitute.d
install -m644 j2se-buildreq-substitute \
    %buildroot%_sysconfdir/buildreqs/packages/substitute.d/%name
install -m644 j2se-devel-buildreq-substitute \
    %buildroot%_sysconfdir/buildreqs/packages/substitute.d/%name-devel

%__install -d %buildroot%_altdir

# J2SE alternative
%__cat <<EOF >%buildroot%_altdir/%altname-java
%{_bindir}/java	%{_jvmdir}/%{jredir}/bin/java	%priority
%_man1dir/java.1.gz	%_man1dir/java%{label}.1.gz	%{_jvmdir}/%{jredir}/bin/java
EOF
# binaries and manuals
for i in keytool policytool servertool pack200 unpack200 \
orbd rmid rmiregistry tnameserv
do
  %__cat <<EOF >>%buildroot%_altdir/%altname-java
%_bindir/$i	%{_jvmdir}/%{jredir}/bin/$i	%{_jvmdir}/%{jredir}/bin/java
%_man1dir/$i.1.gz	%_man1dir/${i}%{label}.1.gz	%{_jvmdir}/%{jredir}/bin/java
EOF
done

# ----- JPackage compatibility alternatives ------
%__cat <<EOF >>%buildroot%_altdir/%altname-java
%{_jvmdir}/jre	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmjardir}/jre	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmdir}/jre-%{origin}	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmjardir}/jre-%{origin}	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmdir}/jre-%{javaver}	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmjardir}/jre-%{javaver}	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
EOF
%if_enabled moz_plugin
%__cat <<EOF >>%buildroot%_altdir/%altname-java
%{_bindir}/ControlPanel	%{_jvmdir}/%{jredir}/bin/ControlPanel	%{_jvmdir}/%{jredir}/bin/java
%{_bindir}/jcontrol	%{_jvmdir}/%{jredir}/bin/jcontrol	%{_jvmdir}/%{jredir}/bin/java
EOF
%endif
# JPackage specific: alternatives for security policy
if [ -e %buildroot%{_jvmprivdir}/%{name}/jce/vanilla/local_policy.jar ]; then
    %__cat <<EOF >>%buildroot%_altdir/%altname-java
%{_jvmdir}/%{jrelnk}/lib/security/local_policy.jar	%{_jvmprivdir}/%{name}/jce/vanilla/local_policy.jar	%{priority}
%{_jvmdir}/%{jrelnk}/lib/security/US_export_policy.jar	%{_jvmprivdir}/%{name}/jce/vanilla/US_export_policy.jar	%{_jvmprivdir}/%{name}/jce/vanilla/local_policy.jar
EOF
fi
# ----- end: JPackage compatibility alternatives ------


# Javac alternative
%__cat <<EOF >%buildroot%_altdir/%altname-javac
%_bindir/javac	%{_jvmdir}/%{sdkdir}/bin/javac	%priority
%_prefix/lib/jdk	%{_jvmdir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%_man1dir/javac.1.gz	%_man1dir/javac%{label}.1.gz	%{_jvmdir}/%{sdkdir}/bin/javac
EOF

# binaries and manuals
for i in appletviewer extcheck idlj jar jarsigner javadoc javah javap jdb native2ascii rmic serialver apt jconsole jinfo jmap jps jsadebugd jstack jstat jstatd \
jhat jrunscript jvisualvm schemagen wsgen wsimport xjc
do
  if [ -e $RPM_BUILD_ROOT%{_jvmdir}/%{sdkdir}/bin/$i ]; then
  %__cat <<EOF >>%buildroot%_altdir/%altname-javac
%_bindir/$i	%{_jvmdir}/%{sdkdir}/bin/$i	%{_jvmdir}/%{sdkdir}/bin/javac
%_man1dir/$i.1.gz	%_man1dir/${i}%{label}.1.gz	%{_jvmdir}/%{sdkdir}/bin/javac
EOF
  fi
done
# binaries w/o manuals
for i in HtmlConverter
do
  if [ -e $RPM_BUILD_ROOT%{_jvmdir}/%{sdkdir}/bin/$i ]; then
  %__cat <<EOF >>%buildroot%_altdir/%altname-javac
%_bindir/$i	%{_jvmdir}/%{sdkdir}/bin/$i	%{_jvmdir}/%{sdkdir}/bin/javac
EOF
fi
done

# ----- JPackage compatibility alternatives ------
  %__cat <<EOF >>%buildroot%_altdir/%altname-javac
%{_jvmdir}/java	%{_jvmdir}/%{sdklnk}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmjardir}/java	%{_jvmjardir}/%{sdklnk}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmdir}/java-%{origin}	%{_jvmdir}/%{sdklnk}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmjardir}/java-%{origin}	%{_jvmjardir}/%{sdklnk}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmdir}/java-%{javaver}	%{_jvmdir}/%{sdklnk}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmjardir}/java-%{javaver}	%{_jvmjardir}/%{sdklnk}	%{_jvmdir}/%{sdkdir}/bin/javac
EOF
# ----- end: JPackage compatibility alternatives ------

%if_enabled moz_plugin
# Mozilla plugin alternative
%__cat <<EOF >%buildroot%_altdir/%name-mozilla
%browser_plugins_path/libjavaplugin_oji.so	%mozilla_java_plugin_so	%priority
EOF
%endif	# enabled moz_plugin

%if_enabled javaws
# Java Web Start alternative
%__cat <<EOF >%buildroot%_altdir/%altname-javaws
%_bindir/javaws	%{_jvmdir}/%{jredir}/bin/javaws	%{_jvmdir}/%{jredir}/bin/java
%_man1dir/javaws.1.gz	%_man1dir/javaws%label.1.gz	%{_jvmdir}/%{jredir}/bin/java
EOF
# ----- JPackage compatibility alternatives ------
%__cat <<EOF >>%buildroot%_altdir/%altname-javaws
%{_datadir}/javaws	%{_jvmdir}/%{jredir}/bin/javaws	%{_jvmdir}/%{jredir}/bin/java
EOF
# ----- end: JPackage compatibility alternatives ------
%endif	# enabled javaws

# hack (see altbug #11383) to enshure that all man pages will be compressed
for i in $RPM_BUILD_ROOT%_man1dir/*.1; do
    [ -f $i ] && gzip -9 $i
done

%post
# ----- JPackage stuff ------
if [ -d %{_jvmdir}/%{jrelnk}/lib/security ]; then
  # Need to remove the old jars in order to support upgrading, ugly :(
  # update-alternatives fails silently if the link targets exist as files.
  rm -f %{_jvmdir}/%{jrelnk}/lib/security/{local,US_export}_policy.jar
fi

# %ifnarch x86_64
# if [ -f %{_sysconfdir}/mime.types ]; then
#    %__subst 's|application/x-java-jnlp-file.*||g' %{_sysconfdir}/mailcap.bak 2>/dev/null
#    echo "type=application/x-java-jnlp-file; description=\"Java Web Start\"; exts=\"jnlp\"" >> %{_sysconfdir}/mailcap 2>/dev/null

#    %__subst 's|application/x-java-jnlp-file.*||g' %{_sysconfdir}/mime.types 2>/dev/null
#    echo "application/x-java-jnlp-file      jnlp" >> %{_sysconfdir}/mime.types 2>/dev/null
# fi
# %endif
# ----- JPackage stuff ------
%force_update_alternatives

##################################################
# - END alt linux specific, shared with openjdk -#
##################################################



!);

    $jpp->_reset_speclist();

    #ppc support
    $jpp->get_section('package','devel')->push_body('
# hack for missing java 1.5.0 on ppc
%ifarch ppc ppc64
Provides: java-devel = 1.5.0
%endif
');
};


__END__
    # deprecated
    unless ('old java w/visualvm') {
    $jpp->get_section('install')->push_body(q!
# dirty, dirty hack :(
pushd %buildroot%{_jvmdir}/%{sdkdir}/lib/visualvm/profiler3/lib/deployed
rm -rf jdk1?/{mac,solaris-amd64,solaris-i386,solaris-sparc,solaris-sparcv9,windows,windows-amd64}
%ifarch %{ix86}
rm -rf jdk1?/linux-amd64
%endif
%ifarch x86_64
rm -rf jdk1?/linux
%endif
popd
!);
	$mainsec->unshift_body(q'%def_enable visualvm'."\n");
	$jpp->get_section('build')->subst(qr'--enable-visualvm','%{subst_enable visualvm}');
	# to disable visualvm w/o netbeans
	$jpp->get_section('files','devel')->unshift_body_before(qr'visualvm.desktop','%if_enabled visualvm'."\n");
	$jpp->get_section('files','devel')->unshift_body_after(qr'visualvm.desktop','%endif'."\n");
	$jpp->get_section('files','devel')->subst(qr'visualvm.desktop','%{name}-jvisualvm.desktop');
    }

    # chrpath hack (disabled)
    if (0) {
	$mainsec->push_body(q'# hack :(
BuildRequires: chrpath
# todo: remove after as-needed fix
%set_verify_elf_method unresolved=relaxed
');
	$jpp->get_section('install')->push_body(q!
# chrpath hack :(
find $RPM_BUILD_ROOT -name '*.so' -exec chrpath -d {} \;
find $RPM_BUILD_ROOT/%{sdkbindir}/ -exec chrpath -d {} \;
find $RPM_BUILD_ROOT/%{_jvmdir}/%{jredir}/bin/ -exec chrpath -d {} \;
!);
    }
    # end chrpath hack

