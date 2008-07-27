#!/usr/bin/perl -w

push @PREHOOKS, sub {
    my ($jpp, $alt) = @_;
    my %type=map {$_=>1} qw/post postun/;
    my %pkg=map {$_=>1} '', 'devel','plugin';
    my @newsec=grep {not $type{$_->get_type()} or not $pkg{$_->get_package()}} $jpp->get_sections();
    $jpp->set_sections(\@newsec);
};

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # added in 16 - TODO - comment out
    #$jpp->get_section('package','')->unshift_body('BuildRequires: eclipse-ecj'."\n");

    $jpp->get_section('package','')->unshift_body(q'BuildRequires: gcc-c++ libstdc++-devel-static
BuildRequires(pre): browser-plugins-npapi-devel
# hack :(
# BuildRequires: chrpath
# todo: remove after as-needed fix
%set_verify_elf_method unresolved=relaxed

%def_enable javaws
%def_enable moz_plugin
%def_disable desktop
');
    $jpp->get_section('package','')->push_body('%define mozilla_java_plugin_so %{_jvmdir}/%{jrelnk}/lib/%{archinstall}/gcjwebplugin.so
%define altname %name
%define label -%{name}
%define javaws_ver      %{javaver}
');

    map {if ($_->get_type() eq "package") {
	$_->subst_if(qr'^Provides:','#Provides:','java-1.7.0-icedtea');
	$_->subst_if(qr'^Obsoletes:','#Obsoletes:','java-1.7.0-icedtea');
	 }
    } $jpp->get_sections();

    $jpp->get_section('package','')->subst(qr'define runtests 1','define runtests 0');
    $jpp->get_section('package','plugin')->subst_if(qr'\%\{syslibdir\}/mozilla/plugins','browser-plugins-npapi',qr'^Requires:');
    $jpp->get_section('package','')->subst(qr'^\%define _libdir','# define _libdir');
    $jpp->get_section('package','')->subst(qr'^\%define syslibdir','# define syslibdir');

    # for M40; can(should?) be disabled on M41
    $jpp->get_section('package','')->subst(qr'lesstif-devel','openmotif-devel');
    $jpp->get_section('package','')->subst(qr'java-1.5.0-gcj-devel','java-1.6.0-sun-devel');
    #$jpp->get_section('package','')->subst(qr'java-1.6.0-openjdk-devel','java-1.6.0-sun-devel');
    $jpp->get_section('package','')->subst(qr'gecko-devel','firefox-devel');
    $jpp->get_section('package','')->subst(qr'^Epoch:\s+1','Epoch: 0');

    $jpp->copy_to_sources('java-1.6.0-openjdk-alt-ldflag.patch');
    $jpp->copy_to_sources('java-1.6.0-openjdk-alt-as-needed1.patch');
    $jpp->get_section('package','')->unshift_body(q{
Patch33: java-1.6.0-openjdk-alt-ldflag.patch
Patch34: java-1.6.0-openjdk-alt-as-needed1.patch
});

    $jpp->get_section('build')->unshift_body('unset JAVA_HOME'."\n");
    $jpp->get_section('build')->subst(qr'./configure','./configure --with-openjdk-home=/usr/lib/jvm/java');
    $jpp->get_section('build')->unshift_body_after(q'patch -p1 < %{PATCH33}
patch -p1 < %{PATCH34}
',qr'make stamps/patch.stamp');
    # hack for sun-based build (i586) only!!!
    $jpp->get_section('build')->subst(qr'^\s*make','make MEMORY_LIMIT=-J-Xmx512m');
    # builds end up randomly :(
    $jpp->get_section('build')->subst(qr'kill -9 `cat Xvfb.pid`','kill -9 `cat Xvfb.pid` || :');

    $jpp->get_section('install')->unshift_body('unset JAVA_HOME'."\n");
    $jpp->get_section('install')->subst(qr'mv bin/java-rmi.cgi sample/rmi','#mv bin/java-rmi.cgi sample/rmi');

    # TODO: fix caserts!!!
    if ('with static caserts') {
	$jpp->get_section('install')->unshift_body_before('if /bin/false; then'."\n",qr'# Install cacerts symlink.');
	$jpp->get_section('install')->unshift_body_before('fi'."\n",qr'# Install extension symlinks.');
    }

    # desktop-file-install is crying! TODO: replace with ALT
    $jpp->get_section('install')->unshift_body_after('install -D -m644 $e.desktop $RPM_BUILD_ROOT%{_datadir}/applications/$e.desktop'."\n",qr'for e in jconsole policytool');
    $jpp->get_section('install')->unshift_body_after('install -D -m644 javaws.desktop $RPM_BUILD_ROOT%{_datadir}/applications/javaws.desktop'."\n",qr'cp javaws.png');
    $jpp->get_section('install')->subst(qr'desktop-file-install','#desktop-file-install');
    $jpp->get_section('install')->subst(qr'--dir(\s*|=)\$RPM_BUILD_ROOT','#--dir $RPM_BUILD_ROOT');

    # chrpath hack (disabled)
    if (0) {
	$jpp->get_section('package','')->push_body(q'# hack :(
BuildRequires: chrpath
# todo: remove after as-needed fix
%set_verify_elf_method unresolved=relaxed
');
	$jpp->get_section('install')->push_body(q!
# chrpath hack :(
find $RPM_BUILD_ROOT -name '*.so' -exec chrpath -d {} \;
find $RPM_BUILD_ROOT/%{sdkbindir}/ -exec chrpath -d {} \;
find $RPM_BUILD_ROOT/%{jrebindir}/ -exec chrpath -d {} \;
!);
    }
    # end chrpath hack

    $jpp->get_section('files','')->subst(qr'#\%ghost \%{_jvmdir}/\%{jredir}/lib/security','%ghost %{_jvmdir}/%{jredir}/lib/security');

# --- alt linux specific, shared with openjdk ---#
    $jpp->raw_rename_section('plugin','-n mozilla-plugin-%name');
    $jpp->get_section('package','devel')->push_body(q!
%package        alsa
Summary:        ALSA support for %{name}
Group:          Development/Java
Requires:       %{name} = %{version}-%{release}

%description    alsa
This package contains Advanced Linux Sound Architecture (ALSA) support
libraries for %{name}.

%package        jdbc
Summary:        Native library for JDBC support in Java
Group:          Development/Databases
Provides:       j2se-jdbc = %javaver
Requires:       %name = %version-%release

%description    jdbc
This package contains the JDBC/ODBC bridge driver for %{name}.

%if_enabled javaws
%package javaws
Summary: Java Web Start
Group: Networking/Other
Requires: %name = %version-%release
Requires(post,preun): alternatives >= 0.2.0
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

    $jpp->get_section('files','')->unshift_body('%_altdir/%altname-java
%_sysconfdir/buildreqs/packages/substitute.d/%name
');
    $jpp->get_section('files','devel')->unshift_body('%_altdir/%altname-javac
%_sysconfdir/buildreqs/packages/substitute.d/%name-devel
');
    $jpp->_reset_speclist();
    $jpp->add_section('files','javaws');
    #map{$_->describe()} $jpp->get_sections();

    $jpp->get_section('files','javaws')->unshift_body('%_altdir/%altname-javaws
%{_datadir}/applications/%{name}-javaws.desktop
');
    $jpp->get_section('files','-n mozilla-plugin-%name')->unshift_body('%_altdir/%altname-mozilla
%{_datadir}/applications/%{name}-control-panel.desktop
');

# I did!!!
#s,%altname-j2se,%altname-java,g
    $jpp->get_section('install')->push_body(q!
# HACK around find-requires
%define __find_requires    $RPM_BUILD_ROOT/.find-requires
cat > $RPM_BUILD_ROOT/.find-requires <<EOF
(/usr/lib/rpm/find-requires | grep -v %{_jvmdir}/%{sdkdir} | sed -e s,^/usr/lib64/lib,lib, | sed -e s,^/usr/lib/lib,lib,) || :
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
%{_bindir}/java	%{jrebindir}/java	%priority
%_man1dir/java.1.gz	%_man1dir/java%{label}.1.gz	%{jrebindir}/java
EOF
# binaries and manuals
for i in keytool policytool servertool pack200 unpack200 \
orbd rmid rmiregistry tnameserv
do
  %__cat <<EOF >>%buildroot%_altdir/%altname-java
%_bindir/$i	%{_jvmdir}/%{jredir}/bin/$i	%{jrebindir}/java
%_man1dir/$i.1.gz	%_man1dir/${i}%{label}.1.gz	%{jrebindir}/java
EOF
done

# ----- JPackage compatibility alternatives ------
%__cat <<EOF >>%buildroot%_altdir/%altname-java
%{_jvmdir}/jre	%{_jvmdir}/%{jrelnk}	%{jrebindir}/java
%{_jvmjardir}/jre	%{_jvmjardir}/%{jrelnk}	%{jrebindir}/java
%{_jvmdir}/jre-%{origin}	%{_jvmdir}/%{jrelnk}	%{jrebindir}/java
%{_jvmjardir}/jre-%{origin}	%{_jvmjardir}/%{jrelnk}	%{jrebindir}/java
%{_jvmdir}/jre-%{javaver}	%{_jvmdir}/%{jrelnk}	%{jrebindir}/java
%{_jvmjardir}/jre-%{javaver}	%{_jvmjardir}/%{jrelnk}	%{jrebindir}/java
EOF
%if_enabled moz_plugin
%__cat <<EOF >>%buildroot%_altdir/%altname-java
%{_bindir}/ControlPanel	%{jrebindir}/ControlPanel	%{jrebindir}/java
%{_bindir}/jcontrol	%{jrebindir}/jcontrol	%{jrebindir}/java
EOF
%endif
# JPackage specific: alternatives for security policy
%__cat <<EOF >>%buildroot%_altdir/%altname-java
%{_jvmdir}/%{jrelnk}/lib/security/local_policy.jar	%{_jvmprivdir}/%{name}/jce/vanilla/local_policy.jar	%{priority}
%{_jvmdir}/%{jrelnk}/lib/security/US_export_policy.jar	%{_jvmprivdir}/%{name}/jce/vanilla/US_export_policy.jar	%{_jvmprivdir}/%{name}/jce/vanilla/local_policy.jar
EOF
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
  %__cat <<EOF >>%buildroot%_altdir/%altname-javac
%_bindir/$i	%{_jvmdir}/%{sdkdir}/bin/$i	%{_jvmdir}/%{sdkdir}/bin/javac
EOF
done

# ----- JPackage compatibility alternatives ------
  %__cat <<EOF >>%buildroot%_altdir/%altname-javac
%_prefix/lib/j2se	%{_jvmdir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
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
%_bindir/javaws	%{jrebindir}/javaws	%{jrebindir}/java
%_man1dir/javaws.1.gz	%_man1dir/javaws%label.1.gz	%{jrebindir}/java
EOF
# ----- JPackage compatibility alternatives ------
%__cat <<EOF >>%buildroot%_altdir/%altname-javaws
%{_datadir}/javaws	%{jrebindir}/javaws	%{jrebindir}/java
EOF
# ----- end: JPackage compatibility alternatives ------
%endif	# enabled javaws

# hack (see #11383) to enshure that all man pages will be compressed
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
%register_alternatives %altname-java

# though it is useless for openjdk, it is harmless
%pre
[ -L %{_jvmdir}/%{jredir}/lib/fonts ] || %__rm -rf %{_jvmdir}/%{jredir}/lib/fonts
[ -L %{_jvmdir}/%{jredir}/lib/oblique-fonts ] || %__rm -rf %{_jvmdir}/%{jredir}/lib/oblique-fonts

%preun
%unregister_alternatives %altname-java

%post devel
%register_alternatives %altname-javac
%update_menus

%preun devel
%unregister_alternatives %altname-javac

%postun devel
%clean_menus

%if_enabled desktop
%post -n java-%{origin}-desktop
%update_mimedb
%update_desktopdb

%postun -n java-%{origin}-desktop
%clean_mimedb
%clean_desktopdb
%endif

%if_enabled moz_plugin
%post -n mozilla-plugin-%name
if [ -d %browser_plugins_path ]; then
    %register_alternatives %name-mozilla
fi
%update_menus

%preun -n mozilla-plugin-%name
%unregister_alternatives %name-mozilla

%postun -n mozilla-plugin-%name
%clean_menus
%endif	# enabled moz_plugin

%if_enabled javaws
%post javaws
%register_alternatives %altname-javaws
%update_menus
%update_desktopdb

%preun javaws
%unregister_alternatives %altname-javaws

%postun javaws
%clean_menus
%clean_desktopdb
%endif # enabled javaws

##################################################
# - END alt linux specific, shared with openjdk -#
##################################################

!);

}


__END__
### original alternatives
%post
ext=.gz
%register_alternatives java_%{name}
%register_alternatives jre_%{origin}_%{name}
%register_alternatives jre_%{javaver}_%{name}
%register_alternatives %{localpolicy}_%{name}

# Update for jnlp handling.
update-desktop-database -q %{_datadir}/applications || :

touch --no-create %{_datadir}/icons/hicolor
if [ -x %{_bindir}/gtk-update-icon-cache ] ; then
  %{_bindir}/gtk-update-icon-cache --quiet %{_datadir}/icons/hicolor
fi

%postun
if [ $1 -eq 0 ]
then
  %unregister_alternatives java_%{name}
  %unregister_alternatives jre_%{origin}_%{name}
  %unregister_alternatives jre_%{javaver}_%{name}
  %unregister_alternatives %{localpolicy}_%{name}
fi

# Update for jnlp handling.
update-desktop-database -q %{_datadir}/applications || :

touch --no-create %{_datadir}/icons/hicolor
if [ -x %{_bindir}/gtk-update-icon-cache ] ; then
  %{_bindir}/gtk-update-icon-cache --quiet %{_datadir}/icons/hicolor
fi

%post devel
ext=.gz
%register_alternatives javac_%{name}-devel
%register_alternatives java_sdk_%{origin}_%{name}-devel
%register_alternatives java_sdk_%{javaver}_%{name}-devel

%postun devel
if [ $1 -eq 0 ]
then
  %unregister_alternatives javac_%{name}-devel
  %unregister_alternatives java_sdk_%{origin}_%{name}-devel
  %unregister_alternatives java_sdk_%{javaver}_%{name}-devel
fi

%post javadoc
%register_alternatives javadocdir_%{name}-javadoc

%postun javadoc
if [ $1 -eq 0 ]
then
  %unregister_alternatives javadocdir_%{name}-javadoc
fi

%post plugin
%register_alternatives %{javaplugin}_%{name}-plugin

%postun plugin
if [ $1 -eq 0 ]
then
  %unregister_alternatives %{javaplugin}_%{name}-plugin
fi