#!/usr/bin/perl -w

push @PREHOOKS, sub {
    my ($spec, $parent) = @_;
    # contain alternatives that we add manually;
    # also, (see https://bugzilla.altlinux.org/32043)
    # fedora alternatives use /mozilla/plugins/libjavaplugin.so - drop!
    map {$spec->get_section($_,'')->delete()} qw/post postun posttrans/;
};

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    #$spec->rename_main_package('mozilla-plugin-java-1.8.0-openjdk');
    my $mainsec=$spec->main_section;

    # man pages are used in alternatives
    $mainsec->unshift_body('%set_compress_method none'."\n");
    $mainsec->unshift_body(q'BuildRequires(pre): browser-plugins-npapi-devel'."\n");

    # remnants?
    $mainsec->exclude_body(qr'^Requires.*:\s+maven-local'."\n");

    $mainsec->unshift_body(q'%def_enable javaws
%def_enable moz_plugin
');
    $mainsec->push_body('
%define altname java-%{javaver}-openjdk
%define origin openjdk
%define label -itweb
%define javaws_ver      %{javaver}
%define sdkdir          java-%{javaver}-openjdk-%{javaver}.0.%{_arch}
# TODO: move here
#define mozilla_java_plugin_so %{_prefix}/lib/%{sdkdir}/IcedTeaPlugin.so
%define mozilla_java_plugin_so %{_libdir}/IcedTeaPlugin.so
#BuildRequires: java-%javaver-%origin-devel
');

    #$spec->get_section('build')->subst_body(qr'./configure','./configure --with-jdk-home=/usr/lib/jvm/java');
    $spec->get_section('build')->subst_body(qr'fedora-','ALTLinux-');

# --- alt linux specific, shared with openjdk ---#

    $spec->get_section('package','')->push_body(q!Provides: icedtea-web = %version-%release
Obsoletes: mozilla-plugin-java-1.7.0-openjdk < 1.5
!);
    $spec->get_section('description','')->push_body(q!
%if_enabled javaws
%package -n %altname-javaws
Summary: Java Web Start
Group: Networking/Other
Requires: %name = %version-%release
Requires(post,preun): alternatives
# --- jpackage compatibility stuff starts here ---
Provides:       javaws = %{javaws_ver}
Obsoletes:      javaws-menu
# --- jpackage compatibility stuff ends here ---
# due to the build specific
Requires: mozilla-plugin-%altname = %version-%release

%description -n %altname-javaws
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

    $spec->add_section('files','-n %altname-javaws');
    #map{$_->describe()} $spec->get_sections();

    $spec->get_section('files','-n %altname-javaws')->unshift_body('#
%_altdir/%altname-javaws
%{_desktopdir}/%{altname}-javaws.desktop
%{_datadir}/pixmaps/javaws.png
%{_man1dir}/javaws-itweb.1.gz
%_bindir/javaws.itweb
');
    $spec->get_section('files','')->push_body('# alt linux specific
%_altdir/%altname-plugin
%{_desktopdir}/%{altname}-control-panel.desktop
# replace by local variants
%exclude %{_desktopdir}/javaws.desktop
%exclude %{_desktopdir}/itweb-settings.desktop
# separate javaws
%exclude %{_desktopdir}/%{altname}-javaws.desktop
%exclude %{_datadir}/pixmaps/javaws.png
%exclude %{_man1dir}/javaws-itweb.1.gz
%exclude %_bindir/javaws.itweb'."\n");

    $spec->_reset_speclist();

    $spec->get_section('install')->push_body(q!
install -d -m 755 %buildroot/etc/icedtea-web
cat > %buildroot/etc/icedtea-web/javaws.policy << EOF
// Based on Oracle JDK policy file
grant codeBase "file:/usr/share/icedtea-web/netx.jar" {
    permission java.security.AllPermission;
};
EOF
sed -e 's,^JAVA_ARGS=,JAVA_ARGS="-Djava.security.policy=/etc/icedtea-web/javaws.policy",' \
%buildroot%_bindir/javaws.itweb
!);

    $spec->get_section('files')->push_body(q!# security policy
%dir /etc/icedtea-web
/etc/icedtea-web/javaws.policy
!);

    $spec->get_section('install')->push_body(q!

##################################################
# --- alt linux specific, shared with openjdk ---#
##################################################
%if_enabled moz_plugin
# ControlPanel freedesktop.org menu entry
cat >> $RPM_BUILD_ROOT%{_desktopdir}/%{altname}-control-panel.desktop << EOF
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
cat >> $RPM_BUILD_ROOT%{_desktopdir}/%{altname}-javaws.desktop << EOF
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


JAVACANDIDATE=`head -2 /etc/alternatives/packages.d/java-%{javaver}-openjdk-java| tail -1 | awk '{print $3}'`

install -d %buildroot%_altdir
%if_enabled moz_plugin
# Mozilla plugin alternative
%__cat <<EOF >%buildroot%_altdir/%altname-plugin
%browser_plugins_path/libjavaplugin_oji.so	%mozilla_java_plugin_so	%priority
EOF
%__cat <<EOF >>%buildroot%_altdir/%altname-plugin
%{_bindir}/ControlPanel	%_bindir/itweb-settings.itweb	$JAVACANDIDATE
%{_bindir}/jcontrol	%_bindir/itweb-settings.itweb	$JAVACANDIDATE
EOF
%endif

%if_enabled javaws
# Java Web Start alternative
cat <<EOF >%buildroot%_altdir/%altname-javaws
%_bindir/javaws	%_bindir/javaws.itweb	$JAVACANDIDATE
%_man1dir/javaws.1.gz	%_man1dir/javaws%label.1.gz	$JAVACANDIDATE
EOF
# ----- JPackage compatibility alternatives ------
%__cat <<EOF >>%buildroot%_altdir/%altname-javaws
%{_datadir}/javaws	%_bindir/javaws.itweb	$JAVACANDIDATE
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
