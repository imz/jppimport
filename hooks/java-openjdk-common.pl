#!/usr/bin/perl -w

$__jre::dir='%{sdkdir}';

push @PREHOOKS, sub {
    my ($spec,) = @_;
    my %type=map {$_=>1} qw/post postun pretrans posttrans/;
    # TODO: javadoc alternatives: not provided.
    # TODO: add proper alternatives to javadoc manually (and check java-1.7.0-oracle too!)
    my %pkg=map {$_=>1} '', 'devel', 'headless', 'javadoc';
    my @newsec=grep {not $type{$_->get_type()} or not $pkg{$_->get_raw_package()}} $spec->get_sections();
    $spec->set_sections(\@newsec);

    # fc specific _privatelibs prov/req exclude
    $spec->main_section->map_body(
	sub{
	    s/^(\%global\s+_privatelibs)/#$1/;
	    $_='' if m/^\%global\s+__(?:provides|requires)_exclude\s+\^\(\%\{_privatelibs\}\)\$/;
	});
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
    my ($spec,) = @_;
    my $mainsec=$spec->main_section;

    #Zerg: А у меня  java-1.8.0-openjdk-devel при установленным
    # java-1.8.0-openjdk-headless вытащил java-1.6.0-sun-headless через зависимость
    # на /usr/bin/java и не дает удалить.
    $mainsec->unshift_body('%filter_from_requires /.usr.bin.java/d'."\n");

    # man pages are used in alternatives
    $mainsec->unshift_body('%set_compress_method none'."\n");

    $spec->get_section('files','headless')->push_body('# sisyphus_check
%dir %{_jvmdir}/'.$__jre::dir.'/lib/security/policy
%dir %{_jvmdir}/'.$__jre::dir.'/lib/security/policy/limited
%dir %{_jvmdir}/'.$__jre::dir.'/lib/security/policy/unlimited'."\n") if $__jre::dir eq '%{jredir}';

    $mainsec->unshift_body(q'BuildRequires: unzip gcc-c++ libstdc++-devel-static
BuildRequires: libXext-devel libXrender-devel libXcomposite-devel
#BuildRequires: libfreetype-devel libkrb5-devel
BuildRequires(pre): browser-plugins-npapi-devel lsb-release
BuildRequires(pre): rpm-macros-java
#BuildRequires: pkgconfig(gtk+-2.0)
');

    $mainsec->unshift_body(q'%def_enable accessibility
%def_disable jvmjardir
%def_disable javaws
%def_disable moz_plugin
%def_disable control_panel
%def_disable desktop
%def_disable systemtap
');

    $mainsec->push_body('
%define altname %name
%define label -%{name}
%define javaws_ver      %{javaver}
');

    # gnustep-sqlclient; it follows the symliks and links with
    # %{_jvmdir}/'.$__jre::dir.' path, that is version/release sensitive.
# # findprov below did not help at all :(
# %add_findprov_lib_path %{_jvmdir}/'.$__jre::dir.'/lib/%archinstall
# %add_findprov_lib_path %{_jvmdir}/'.$__jre::dir.'/lib/%archinstall/jli
# # it is needed for those apps which links with libjvm.so
# %add_findprov_lib_path %{_jvmdir}/'.$__jre::dir.'/lib/%archinstall/server
# %ifnarch x86_64
# %add_findprov_lib_path %{_jvmdir}/'.$__jre::dir.'/lib/%archinstall/client
# %endif
    $mainsec->push_body('
%if "%{_lib}" == "lib64"
Provides: /usr/lib/jvm/java/jre/lib/%archinstall/server/libjvm.so()(64bit)
Provides: /usr/lib/jvm/java/jre/lib/%archinstall/server/libjvm.so(SUNWprivate_1.1)(64bit)
Provides: %{_jvmdir}/'.$__jre::dir.'/lib/%archinstall/server/libjvm.so()(64bit)
Provides: %{_jvmdir}/'.$__jre::dir.'/lib/%archinstall/server/libjvm.so(SUNWprivate_1.1)(64bit)
%else
Provides: /usr/lib/jvm/java/jre/lib/%archinstall/server/libjvm.so()
Provides: /usr/lib/jvm/java/jre/lib/%archinstall/server/libjvm.so(SUNWprivate_1.1)
Provides: %{_jvmdir}/'.$__jre::dir.'/lib/%archinstall/server/libjvm.so()
Provides: %{_jvmdir}/'.$__jre::dir.'/lib/%archinstall/server/libjvm.so(SUNWprivate_1.1)
%endif
');

    $mainsec=$spec->main_section;
    $mainsec->set_tag('Epoch','0') if $mainsec->match_body(qr'^Epoch:\s+[1-9]');

    my $headlsec=$spec->get_section('package','headless');
    $headlsec->push_body('Requires: java-common'."\n");
    $headlsec->push_body('Requires: /proc'."\n");
    $headlsec->push_body(q!Requires(post): /proc!."\n");
    $headlsec->map_body(sub{s,^(Requires:),#$1, if /copy-jdk-configs/});

    $spec->get_section('build')->map_body(sub{
	# DISTRO_PACKAGE_VERSION="fedora-...
	s,(?:fedora|rhel)-,ALTLinux-,;
	# DISTRO_NAME="Fedora" "Red Hat Enterprise Linux 7"
	s,"(?:Fedora|Red Hat Enterprise Linux \d+)","ALTLinux",;
    });

    # do we need it?
    #$spec->get_section('install')->unshift_body('unset JAVA_HOME'."\n");

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
desktop-file-edit --set-key=Name --set-value='OpenJDK %majorver Policy Tool' %buildroot/usr/share/applications/*policytool.desktop
desktop-file-edit --set-key=Comment --set-value='Manage OpenJDK %majorver policy files' %buildroot/usr/share/applications/*policytool.desktop
#Name=OpenJDK 8 Monitoring & Management Console
desktop-file-edit --set-key=Name --set-value='OpenJDK %majorver Management Console' %buildroot/usr/share/applications/*jconsole.desktop
#Comment=Monitor and manage OpenJDK applications
desktop-file-edit --set-key=Comment --set-value='Monitor and manage OpenJDK %majorver' %buildroot/usr/share/applications/*jconsole.desktop

export LANG=ru_RU.UTF-8
desktop-file-edit --set-key=Name[ru] --set-value='Настройка политик OpenJDK %majorver' %buildroot/usr/share/applications/*policytool.desktop
desktop-file-edit --set-key=Comment[ru] --set-value='Управление файлами политик OpenJDK %majorver' %buildroot/usr/share/applications/*policytool.desktop
desktop-file-edit --set-key=Name[ru] --set-value='Консоль OpenJDK %majorver' %buildroot/usr/share/applications/*jconsole.desktop
desktop-file-edit --set-key=Comment[ru] --set-value='Мониторинг и управление приложениями OpenJDK %majorver' %buildroot/usr/share/applications/*jconsole.desktop
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

    # NOTE: s,sdklnk,sdkdir,g
    $spec->get_section('install')->push_body(q!

##################################################
# --- alt linux specific, shared with openjdk ---#
##################################################

install -d -m 755 $RPM_BUILD_ROOT%{_datadir}/applications
if [ -e $RPM_BUILD_ROOT%{_jvmdir}/%{sdkdir}/bin/jvisualvm ]; then
  cat >> $RPM_BUILD_ROOT%{_datadir}/applications/%{name}-jvisualvm.desktop << EOF
[Desktop Entry]
Name=Java VisualVM (OpenJDK %{javaver})
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
Name=Java Control Panel (OpenJDK %{javaver})
Name[ru]=Настройка Java (OpenJDK %{javaver})
Comment=Java Control Panel
Comment[ru]=Панель управления Java
Exec=%{_jvmdir}/!.$__jre::dir.q!/bin/jcontrol
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
Name=Java Web Start ((OpenJDK %{javaver}))
Comment=Java Application Launcher
MimeType=application/x-java-jnlp-file;
Exec=%{_jvmdir}/!.$__jre::dir.q!/bin/javaws %%u
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
%{_bindir}/java	%{_jvmdir}/!.$__jre::dir.q!/bin/java	%priority
%_man1dir/java.1.gz	%_man1dir/java%{label}.1.gz	%{_jvmdir}/!.$__jre::dir.q!/bin/java
EOF
# binaries and manuals
for i in keytool policytool servertool pack200 unpack200 \
orbd rmid rmiregistry tnameserv
do
  cat <<EOF >>%buildroot%_altdir/%name-java-headless
%_bindir/$i	%{_jvmdir}/!.$__jre::dir.q!/bin/$i	%{_jvmdir}/!.$__jre::dir.q!/bin/java
%_man1dir/$i.1.gz	%_man1dir/${i}%{label}.1.gz	%{_jvmdir}/!.$__jre::dir.q!/bin/java
EOF
done

%if_enabled control_panel
cat <<EOF >>%buildroot%_altdir/%name-java
%{_bindir}/ControlPanel	%{_jvmdir}/!.$__jre::dir.q!/bin/ControlPanel	%{_jvmdir}/!.$__jre::dir.q!/bin/java
%{_bindir}/jcontrol	%{_jvmdir}/!.$__jre::dir.q!/bin/jcontrol	%{_jvmdir}/!.$__jre::dir.q!/bin/java
EOF
%endif
# ----- JPackage compatibility alternatives ------
cat <<EOF >>%buildroot%_altdir/%name-java-headless
%{_jvmdir}/jre	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/!.$__jre::dir.q!/bin/java
%{_jvmdir}/jre-%{origin}	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/!.$__jre::dir.q!/bin/java
%{_jvmdir}/jre-%{javaver}	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/!.$__jre::dir.q!/bin/java
%{_jvmdir}/jre-%{javaver}-%{origin}	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/!.$__jre::dir.q!/bin/java
%if_enabled jvmjardir
%{_jvmjardir}/jre	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/!.$__jre::dir.q!/bin/java
%{_jvmjardir}/jre-%{origin}	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/!.$__jre::dir.q!/bin/java
%{_jvmjardir}/jre-%{javaver}	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/!.$__jre::dir.q!/bin/java
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

#error: writeable files in /usr: /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.79-2.5.5.0.x86_64/jre/lib/amd64/server/classes.jsa
#error: writeable files in /usr: /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.79-2.5.5.0.x86_64/jre/lib/amd64/client/classes.jsa
#%attr(664, root, root) %ghost %{_jvmdir}/%{jredir}/lib/%{archinstall}/server/classes.jsa
#%attr(664, root, root) %ghost %{_jvmdir}/%{jredir}/lib/%{archinstall}/client/classes.jsa
    $spec->get_section('files','headless')->subst_body_if(qr/664,/,'644,',qr!classes.jsa!);
};

__END__
TODO:

%ifarch e2k
%global archinstall %{_arch}
%endif



%if_enabled systemtap
%global with_systemtap 1
%else
%global with_systemtap 0
%endif
