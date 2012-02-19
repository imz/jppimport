#!/usr/bin/perl -w

push @PREHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('posttrans','')->delete();
};

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    my $mainsec=$jpp->main_section;

    # man pages are used in alternatives
    $mainsec->unshift_body('%set_compress_method none'."\n");

my $rpminfo='
/usr/bin/itweb-settings.itweb
/usr/bin/javaws.itweb
/usr/lib64/IcedTeaPlugin.so
/usr/share/applications/itweb-settings.desktop
/usr/share/applications/javaws.desktop
/usr/share/doc/icedtea-web-1.1.4
/usr/share/doc/icedtea-web-1.1.4/COPYING
/usr/share/doc/icedtea-web-1.1.4/NEWS
/usr/share/doc/icedtea-web-1.1.4/README
/usr/share/icedtea-web
/usr/share/icedtea-web/about.jar
/usr/share/icedtea-web/about.jnlp
/usr/share/icedtea-web/netx.jar
/usr/share/icedtea-web/plugin.jar
/usr/share/man/man1/javaws-itweb.1.gz
/usr/share/pixmaps/javaws.png

%define min_openjdk_version 1:1.6.0.0-60
%define multilib_arches ppc64 sparc64 x86_64

# Version of java
%define javaver 1.7.0

# For the mozilla plugin dir
Requires:       mozilla-filesystem%{?_isa}

Provides:   java-1.6.0-openjdk-plugin = %{min_openjdk_version}
Obsoletes:  java-1.6.0-openjdk-plugin <= %{min_openjdk_version}
';

    $mainsec->unshift_body(q'
BuildRequires(pre): browser-plugins-npapi-devel
BuildRequires(pre): rpm-build-java
');

    $mainsec->unshift_body(q'%def_enable javaws
');
    $mainsec->push_body('
%define altname %name
%define origin openjdk
%define label -itweb
%define javaws_ver      %{javaver}
%define sdkdir          java-%{javaver}-openjdk-%{javaver}.0.%{_arch}
# TODO: move here
%define mozilla_java_plugin_so %{_libdir}/%{sdkdir}/IcedTeaPlugin.so
BuildRequires: java-%javaver-%origin-devel
');

    #$jpp->get_section('build')->subst(qr'./configure','./configure --with-jdk-home=/usr/lib/jvm/java');
    $jpp->get_section('build')->subst(qr'fedora-','ALTLinux-');

# --- alt linux specific, shared with openjdk ---#

    if (0 and 'has plugin') {
	$jpp->get_section('package','plugin')->subst_if(qr'mozilla-filesystem','browser-plugins-npapi',qr'^Requires:');
	$jpp->rename_package('plugin','-n mozilla-plugin-%name');
	$jpp->get_section('files','-n mozilla-plugin-%name')->unshift_body('%_altdir/%altname-mozilla
%{_datadir}/applications/%{name}-control-panel.desktop
');
    }

    $jpp->get_section('package','')->push_body(q!
%if_enabled javaws
%package javaws
Summary: Java Web Start
Group: Networking/Other
Requires: %name = %version-%release
Requires(post,preun): alternatives
# --- jpackage compatibility stuff starts here ---
Provides:       javaws = %{javaws_ver}
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
    #map{$_->describe()} $jpp->get_sections();

    $jpp->get_section('files','javaws')->unshift_body('%_altdir/%altname-javaws
%{_datadir}/applications/%{name}-javaws.desktop
');
    $jpp->_reset_speclist();

    $jpp->get_section('install')->push_body(q!

##################################################
# --- alt linux specific, shared with openjdk ---#
##################################################
%if_enabled moz_plugin
# ControlPanel freedesktop.org menu entry
cat >> $RPM_BUILD_ROOT%{_datadir}/applications/%{name}-control-panel.desktop << EOF
[Desktop Entry]
Name=Java Plugin Control Panel (%{name})
Comment=Java Control Panel
Exec=itweb-settings.itweb
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
Exec=javaws.itweb %%u
Icon=%{name}
Terminal=false
Type=Application
Categories=Settings;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};
EOF
%endif

install -d %buildroot%_altdir

# ----- JPackage compatibility alternatives ------
%if_enabled moz_plugin
cat <<EOF >>%buildroot%_altdir/%altname-java
%{_bindir}/ControlPanel	%{jredir}/bin/ControlPanel	%{jredir}/bin/java
%{_bindir}/jcontrol	%{jredir}/bin/jcontrol	%{jredir}/bin/java
EOF
%endif
# ----- end: JPackage compatibility alternatives ------

%if_enabled moz_plugin
# Mozilla plugin alternative
%__cat <<EOF >%buildroot%_altdir/%name-mozilla
%browser_plugins_path/libjavaplugin_oji.so	%mozilla_java_plugin_so	%priority
EOF
%endif	# enabled moz_plugin
%if_enabled moz_plugin
%__cat <<EOF >>%buildroot%_altdir/%name-java
%{_bindir}/ControlPanel	%_bindir/itweb-settings.itweb	%{jredir}/bin/java
%{_bindir}/jcontrol	%_bindir/itweb-settings.itweb	%{jredir}/bin/java
EOF
%endif

%if_enabled javaws
# Java Web Start alternative
cat <<EOF >%buildroot%_altdir/%altname-javaws
%_bindir/javaws	%_bindir/javaws.itweb	%{_jvmdir}/%{jredir}/bin/java
%_man1dir/javaws.1.gz	%_man1dir/javaws%label.1.gz	%{jredir}/bin/java
EOF
# ----- JPackage compatibility alternatives ------
%__cat <<EOF >>%buildroot%_altdir/%altname-javaws
%{_datadir}/javaws	%_bindir/javaws.itweb	%{jredir}/bin/java
EOF
# ----- end: JPackage compatibility alternatives ------
%endif	# enabled javaws

# hack (see #11383) to enshure that all man pages will be compressed
for i in $RPM_BUILD_ROOT%_man1dir/*.1; do
    [ -f $i ] && gzip -9 $i
done

##################################################
# - END alt linux specific, shared with openjdk -#
##################################################
!);

};


__END__
