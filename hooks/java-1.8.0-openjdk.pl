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
    my %type=map {$_=>1} qw/post postun pretrans posttrans/;
    # TODO: javadoc alternatives: not provided.
    # TODO: add proper alternatives to javadoc manually (and check java-1.7.0-oracle too!)
    my %pkg=map {$_=>1} '', 'devel', 'headless', 'javadoc';
    my @newsec=grep {not $type{$_->get_type()} or not $pkg{$_->get_raw_package()}} $jpp->get_sections();
    $jpp->set_sections(\@newsec);

    #### cleaning up macros for devel subpackages

    my %macrosave=map {$_=>[]} qw/files_jre files_jre_headless files_devel files_demo files_src files_javadoc files_accessibility java_rpo java_headless_rpo java_devel_rpo java_demo_rpo java_javadoc_rpo java_src_rpo java_accessibility_rpo/;
    my @filtered;
    my $multidrop=0;
    my $multisave;
    my $mainsec=$jpp->main_section;
    foreach my $line (@{$mainsec->get_bodyref}) {
	if ($multidrop) {
	    if ($line=~/^\}\s*$/) {
		##warn "E1END: $line";
		$multidrop=0;
	    } else {
		##warn "E1BODY: $line";
	    }
	} elsif ($multisave) {
	    if ($line=~/^\}\s*$/) {
		##warn "E2END: $line";
		$multisave=undef;
	    } else {
		##warn "E2BODY: $line";
		$line=~s/\%1//g;
		push @{$macrosave{$multisave}}, $line;
	    }
	} else {
	    if ($line=~/^\%global\s+(?:post_script|postun_script|post_headless|postun_headless|post_devel|postun_devel|posttrans_devel|posttrans_script|post_javadoc|postun_javadoc)\(\)\s+\%\{expand:/) {
		$multidrop=1;
		#warn "E1HEAD: $line";
	    } elsif ($line=~m!^(?:# not-duplicated scriplets|# not-duplicated requires/provides/obsolate|\%global\s+update_desktop_icons)!) {
		##warn "E1SKIP: $line";
	    } elsif ($line=~/^\%global\s+(\w+)\(\)\s+\%\{expand:/ && $macrosave{$1}) {
		$multisave=$1;
		#warn "E2HEAD: $line";
	    } else {
		push @filtered, $line;
	    }
	}
    }
    $mainsec->set_body(\@filtered);

    foreach my $sec ($jpp->get_sections()) {
	$sec->delete() if ($sec->get_raw_package() =~ /debug$/);
    }

    $jpp->applied_off();
    foreach my $sec ($jpp->get_sections()) {
	$sec->apply_body(
	    sub {
		my ($line)=@_;
		if ($line=~/^\%\{(\w+)\s+\%\{nil\}\}/ && $macrosave{$1}) {
		    return @{$macrosave{$1}};
		} else {
		    return $line;
		}
	    }
	    );
#%global sdkdir()        %{expand:%{uniquesuffix %%1}}
#%global jrelnk()        %{expand:jre-%{javaver}-%{origin}-%{version}-%{release}.%{_arch}%1}
#%global jredir()        %{expand:%{sdkdir %%1}/jre}
#%global sdkbindir()     %{expand:%{_jvmdir}/%{sdkdir %%1}/bin}
#%global jrebindir()     %{expand:%{_jvmdir}/%{jredir %%1}/bin}
#%global jvmjardir()     %{expand:%{_jvmjardir}/%{uniquesuffix %%1}}
	$sec->map_body(
	    sub {
		s,\%\{(buildoutputdir|uniquejavadocdir|uniquesuffix|sdkdir|jrelnk|jredir|sdkbindir|jrebindir|jvmjardir)\s+[^\}]+\},%{$1},g;
	    });

    }
    $jpp->applied_on();
    $jpp->main_section->map_body(
	sub {
	    s,[\%]+[1],, if s,^(\%global\s+(?:buildoutputdir|uniquejavadocdir|uniquesuffix|sdkdir|jrelnk|jredir|sdkbindir|jrebindir|jvmjardir))\(\)\s+\%\{expand:(.+)\}\s*$,$1 $2\n,;
	}
	);
    $jpp->_reset_speclist();
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
	$line=~s/\%if\s+\%{with_systemtap}/\%if_enabled systemtap/g;
	push @newbody, $line;
    }
    $section->set_body(\@newbody);
}

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    my $spec=$jpp;
    my $mainsec=$jpp->main_section;

# TODO: current hack:
# 1) drop custom optflags? 
# 2) add
#sed -i -e 's, -m32, -m32 %optflags_shared -fpic -D_BLA_BLA_BLA1,' openjdk/hotspot/make/linux/makefiles/gcc.make

    #Zerg: А у меня  java-1.8.0-openjdk-devel при установленным
    # java-1.8.0-openjdk-headless вытащил java-1.6.0-sun-headless через зависимость
    # на /usr/bin/java и не дает удалить.
    $mainsec->unshift_body('%filter_from_requires /.usr.bin.java/d'."\n");

    # for %{__global_ldflags} -- might be dropped in the future
    $mainsec->unshift_body('BuildRequires(pre): rpm-macros-fedora-compat'."\n");

    $mainsec->subst_body_if(qr'java-1.8.0-openjdk','java-1.7.0-openjdk',qr'^BuildRequires:');

    # jpp7
    $mainsec->unshift_body('%define with_systemtap 0'."\n");

    # man pages are used in alternatives
    $mainsec->unshift_body('%set_compress_method none'."\n");

    # 1core build (16core build is out of memory)
    # export NUM_PROC=%(/usr/bin/getconf _NPROCESSORS_ONLN 2> /dev/null || :)
    $jpp->get_section('build')->subst_body_if(qr'^export\s+NUM_PROC=','#export NUM_PROC=','_NPROCESSORS_ONLN');

    # no debug build in 1.8.65
    $mainsec->subst_body(qr'^\%global include_debug_build 1','%global include_debug_build 0');

    $jpp->get_section('package','javadoc')->push_body('# fc provides
Provides: java-javadoc = 1:1.9.0
');

    # https://bugzilla.altlinux.org/show_bug.cgi?id=27050
    #$mainsec->unshift_body('%add_verify_elf_skiplist *.debuginfo'."\n");
    $jpp->get_section('prep')->push_body(q!sed -i -e 's,DEF_OBJCOPY=/usr/bin/objcopy,DEF_OBJCOPY=/usr/bin/NO-objcopy,' jdk8/hotspot/make/linux/makefiles/defs.make!."\n");

    # it resolves gcc, g++,  ... etc to gcc_wrapper that breaks c++ linkage (java8 newer bugfixes)
    $jpp->get_section('prep')->push_body(q!sed -i -e /BASIC_REMOVE_SYMBOLIC_LINKS/d jdk8/common/autoconf/toolchain.m4!."\n");

    # i586 build is not included :(
    #$mainsec->subst_body(qr'ifarch i386','ifarch %ix86');
    #$mainsec->subst_body_if(qr'i686','%ix86',qr'^ExclusiveArch:');

    $mainsec=$jpp->main_section;
    $mainsec->exclude_body(qr'^Obsoletes:\s+java-1.7.0-openjdk');
    $mainsec->exclude_body(qr'^Obsoletes:\s+java-1.5.0-gcj');
    $mainsec->exclude_body(qr'^Obsoletes:\s+sinjdoc');
    $jpp->get_section('package','headless')->exclude_body(qr'^Obsoletes:\s+java-1.7.0-openjdk-headless');
    $jpp->get_section('package','devel')->exclude_body(qr'^Obsoletes:\s+java-1.7.0-openjdk-devel');
    $jpp->get_section('package','devel')->exclude_body(qr'^Obsoletes:\s+java-1.5.0-gcj-devel');
    $jpp->get_section('package','demo')->exclude_body(qr'^Obsoletes:\s+java-1.7.0-openjdk-demo');
    $jpp->get_section('package','src')->exclude_body(qr'^Obsoletes:\s+java-1.7.0-openjdk-src');
    $jpp->get_section('package','javadoc')->exclude_body(qr'^Obsoletes:\s+java-1.7.0-openjdk-javadoc');
    $jpp->get_section('package','accessibility')->exclude_body(qr'^Obsoletes:\s+java-1.7.0-openjdk-accessibility');

    $mainsec->unshift_body(q'BuildRequires: unzip gcc-c++ libstdc++-devel-static
BuildRequires: libXext-devel libXrender-devel libfreetype-devel libkrb5-devel
BuildRequires(pre): browser-plugins-npapi-devel lsb-release
BuildRequires(pre): rpm-build-java
BuildRequires: pkgconfig(gtk+-2.0) ant-nodeps
');

    $mainsec->unshift_body(q'%def_enable accessibility
%def_disable javaws
%def_disable moz_plugin
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
    $jpp->add_patch('java-1.8.0-openjdk-alt-no-Werror.patch',STRIP=>1);

    # as-needed link order
    $jpp->add_patch('java-1.8.0-openjdk-alt-link.patch',STRIP=>1);
    $jpp->spec_apply_patch(PATCHFILE=>'java-1.8.0-openjdk-alt-bug-32463.spec.diff');

#map {if ($_->get_type() eq 'package') {
#	$_->subst_if(qr'^Provides:','#Provides:','java-1.7.0-icedtea');
#	$_->subst_if(qr'^Obsoletes:','#Obsoletes:','java-1.7.0-icedtea');
# }
#} $jpp->get_sections();
    
    # already 0
    #$mainsec->subst_body(qr'define runtests 1','define runtests 0');

    #$mainsec->subst_body(qr'^\%define _libdir','# define _libdir');
    #$mainsec->subst_body(qr'^\%define syslibdir','# define syslibdir');

    $mainsec->set_tag('Epoch','0') if $mainsec->match_body(qr'^Epoch:\s+[1-9]');

    my $headlsec=$spec->get_section('package','headless');
    $headlsec->exclude_body('^Requires: maven-local'."\n");
    $headlsec->push_body('Requires: java-common'."\n");
    $headlsec->push_body('Requires: /proc'."\n");
    $headlsec->push_body(q!Requires(post): /proc!."\n");

    # unrecognized option; TODO: check the list
    #$jpp->get_section('build')->subst_body(qr'./configure','./configure --with-openjdk-home=/usr/lib/jvm/java');
    # DISTRO_PACKAGE_VERSION="fedora-...
    $jpp->get_section('build')->subst_body(qr'fedora-','ALTLinux-');
    # DISTRO_NAME="Fedora"
    $jpp->get_section('build')->subst_body(qr'"Fedora"','"ALTLinux"');

    ## TODO: check if it still valid
    # hack for sun-based build (i586) only!!!
    #$jpp->get_section('build')->subst_body(qr'^\s*make','make MEMORY_LIMIT=-J-Xmx512m');

    $jpp->get_section('install')->unshift_body('unset JAVA_HOME'."\n");

    # why do we need it?
    #$jpp->get_section('install')->subst_body(qr'mv bin/java-rmi.cgi sample/rmi',':; #mv bin/java-rmi.cgi sample/rmi');

    # just to suppress warnings on %
    $jpp->get_section('install')->subst_if(qr'\%dir','%%dir','sed');
    $jpp->get_section('install')->subst_if(qr'\%doc','%%doc','sed');

    # TODO: fix caserts generation!!!
    # for proper symlink requires ? 
    $mainsec->unshift_body('BuildRequires: ca-certificates-java'."\n");

    # to disable --enable-systemtap
    #$mainsec->subst_body(qr'--enable-systemtap','%{subst_enable systemtap}');
    &__subst_systemtap($mainsec);
    &__subst_systemtap($jpp->get_section('prep'));
    &__subst_systemtap($jpp->get_section('install'));
    &__subst_systemtap($jpp->get_section('files','devel'));

    # big changelog
    #$jpp->get_section('files','')->subst_body(qr'^\%doc ChangeLog','#doc ChangeLog');

# --- alt linux specific, shared with openjdk ---#
    $jpp->get_section('files','')->unshift_body('%_altdir/%altname-java
%_sysconfdir/buildreqs/packages/substitute.d/%name
');
    $jpp->get_section('files','devel')->unshift_body('%_altdir/%altname-javac
%_sysconfdir/buildreqs/packages/substitute.d/%name-devel
');
    $jpp->_reset_speclist();
    $mainsec=$jpp->main_section;

    $jpp->get_section('install')->push_body(q!
%__subst 's,^Categories=.*,Categories=Settings;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};,' %buildroot/usr/share/applications/*policytool.desktop
%__subst 's,^Categories=.*,Categories=Development;Profiling;System;Monitor;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};,' %buildroot/usr/share/applications/*jconsole.desktop
!);

    $jpp->get_section('install')->push_body(q!
##### javadoc Alt specific #####
echo java-javadoc >java-javadoc-buildreq-substitute
mkdir -p %buildroot%_sysconfdir/buildreqs/packages/substitute.d
install -m644 java-javadoc-buildreq-substitute \
    %buildroot%_sysconfdir/buildreqs/packages/substitute.d/%name-javadoc
install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/%altname-javadoc<<EOF
%{_javadocdir}/java	%{_javadocdir}/%{uniquejavadocdir}/api	%{priority}
EOF
!);
    $jpp->get_section('files','javadoc')->unshift_body('%_altdir/%altname-javadoc
%_sysconfdir/buildreqs/packages/substitute.d/%name-javadoc
');

    # NOTE: s,sdklnk,sdkdir,g
    $jpp->get_section('install')->push_body(q!

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

%if_enabled moz_plugin
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
echo java-devel >j2se-devel-buildreq-substitute
mkdir -p %buildroot%_sysconfdir/buildreqs/packages/substitute.d
install -m644 j2se-buildreq-substitute \
    %buildroot%_sysconfdir/buildreqs/packages/substitute.d/%name
install -m644 j2se-devel-buildreq-substitute \
    %buildroot%_sysconfdir/buildreqs/packages/substitute.d/%name-devel

install -d %buildroot%_altdir

# J2SE alternative
cat <<EOF >%buildroot%_altdir/%name-java
%{_bindir}/java	%{_jvmdir}/%{jredir}/bin/java	%priority
%_man1dir/java.1.gz	%_man1dir/java%{label}.1.gz	%{_jvmdir}/%{jredir}/bin/java
EOF
# binaries and manuals
for i in keytool policytool servertool pack200 unpack200 \
orbd rmid rmiregistry tnameserv
do
  cat <<EOF >>%buildroot%_altdir/%name-java
%_bindir/$i	%{_jvmdir}/%{jredir}/bin/$i	%{_jvmdir}/%{jredir}/bin/java
%_man1dir/$i.1.gz	%_man1dir/${i}%{label}.1.gz	%{_jvmdir}/%{jredir}/bin/java
EOF
done

# ----- JPackage compatibility alternatives ------
cat <<EOF >>%buildroot%_altdir/%name-java
%{_jvmdir}/jre	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmjardir}/jre	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmdir}/jre-%{origin}	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmjardir}/jre-%{origin}	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmdir}/jre-%{javaver}	%{_jvmdir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
%{_jvmjardir}/jre-%{javaver}	%{_jvmjardir}/%{jrelnk}	%{_jvmdir}/%{jredir}/bin/java
EOF
%if_enabled moz_plugin
cat <<EOF >>%buildroot%_altdir/%name-java
%{_bindir}/ControlPanel	%{_jvmdir}/%{jredir}/bin/ControlPanel	%{_jvmdir}/%{jredir}/bin/java
%{_bindir}/jcontrol	%{_jvmdir}/%{jredir}/bin/jcontrol	%{_jvmdir}/%{jredir}/bin/java
EOF
%endif
# JPackage specific: alternatives for security policy
cat <<EOF >>%buildroot%_altdir/%name-java
%{_jvmdir}/%{jrelnk}/lib/security/local_policy.jar	%{_jvmprivdir}/%{name}/jce/vanilla/local_policy.jar	%{priority}
%{_jvmdir}/%{jrelnk}/lib/security/US_export_policy.jar	%{_jvmprivdir}/%{name}/jce/vanilla/US_export_policy.jar	%{_jvmprivdir}/%{name}/jce/vanilla/local_policy.jar
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
%{_jvmjardir}/java	%{_jvmjardir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmdir}/java-%{origin}	%{_jvmdir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmjardir}/java-%{origin}	%{_jvmjardir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmdir}/java-%{javaver}	%{_jvmdir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
%{_jvmjardir}/java-%{javaver}	%{_jvmjardir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac
EOF
##### TODO --- 
#%{_jvmdir}/java-%{javaver}-%{origin}	%{_jvmdir}/%{sdkdir}	%{_jvmdir}/%{sdkdir}/bin/javac

# ----- end: JPackage compatibility alternatives ------

%if_enabled moz_plugin
# Mozilla plugin alternative
cat <<EOF >%buildroot%_altdir/%name-mozilla
%browser_plugins_path/libjavaplugin_oji.so	%mozilla_java_plugin_so	%priority
EOF
%endif	# enabled moz_plugin

%if_enabled javaws
# Java Web Start alternative
cat <<EOF >%buildroot%_altdir/%name-javaws
%_bindir/javaws	%{_jvmdir}/%{jredir}/bin/javaws	%{_jvmdir}/%{jredir}/bin/java
%_man1dir/javaws.1.gz	%_man1dir/javaws%label.1.gz	%{_jvmdir}/%{jredir}/bin/java
EOF
# ----- JPackage compatibility alternatives ------
cat <<EOF >>%buildroot%_altdir/%name-javaws
%{_datadir}/javaws	%{_jvmdir}/%{jredir}/bin/javaws	%{_jvmdir}/%{jredir}/bin/java
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


echo "install passed past alt linux specific."
!);

    #$jpp->_reset_speclist();

    $jpp->add_section('post','headless')->push_body(q@# java should be available ASAP
%force_update_alternatives

%ifarch %{jit_arches}
#see https://bugzilla.redhat.com/show_bug.cgi?id=513605
java=%{jrebindir}/java
if [ -f /proc/cpuinfo ] && ! [ -d /.ours ] ; then #real workstation; not a mkimage-profile, etc
    $java -Xshare:dump >/dev/null 2>/dev/null
fi
%endif
@);

    #### Misterious bug:
    # java -version work with JAVA_HOME=/usr/lib/jvm/java-1.7.0
    # but does not work with JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk
    # both are alternatives, former one works, but later one somehow is broken :(
    $jpp->get_section('build')->subst_body_if(qr/\.0-openjdk/,'.0',qr!JDK_TO_BUILD_WITH=/usr/lib/jvm/java-1.[789].0-openjdk!);

#error: writeable files in /usr: /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.79-2.5.5.0.x86_64/jre/lib/amd64/server/classes.jsa
#error: writeable files in /usr: /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.79-2.5.5.0.x86_64/jre/lib/amd64/client/classes.jsa
#%attr(664, root, root) %ghost %{_jvmdir}/%{jredir}/lib/%{archinstall}/server/classes.jsa
#%attr(664, root, root) %ghost %{_jvmdir}/%{jredir}/lib/%{archinstall}/client/classes.jsa
    $jpp->get_section('files','headless')->subst_body_if(qr/664,/,'644,',qr!classes.jsa!);


    #ppc support
    $jpp->get_section('package','devel')->push_body('
# hack for missing java 1.5.0 on ppc
%ifarch ppc ppc64
Provides: java-devel = 1.5.0
%endif
') if 0; # jdk 1.6 already provides

    $jpp->spec_apply_patch(PATCHSTRING=> q!
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
    # no need in 1.7.0.1
    #$jpp->get_section('install')->subst_if(qr'--vendor=fedora','', qr'desktop-file-install');

    $jpp->get_section('install')->push_body(q!# move soundfont to java
grep /audio/default.sf2 java-1.8.0-openjdk.files-headless >> java-1.8.0-openjdk.files
grep -v /audio/default.sf2 java-1.8.0-openjdk.files-headless > java-1.8.0-openjdk.files-headless-new
mv java-1.8.0-openjdk.files-headless-new java-1.8.0-openjdk.files-headless
!."\n");
    $jpp->get_section('files','headless')->push_body(q!%exclude %{_jvmdir}/%{jredir}/lib/audio/default.sf2!."\n");

    $jpp->get_section('package','')->subst_body(qr'^BuildRequires: libat-spi-devel','#BuildRequires: libat-spi-devel');
    $jpp->main_section->subst_body_if(qr'xorg-x11-utils','xset xhost',qr'^BuildRequires:');

    # builds end up randomly :(
    $jpp->get_section('build')->subst_body(qr'kill -9 `cat Xvfb.pid`','kill -9 `cat Xvfb.pid` || :');

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

    $jpp->get_section('install')->push_body(q!
# HACK around find-requires
%define __find_requires    $RPM_BUILD_ROOT/.find-requires
cat > $RPM_BUILD_ROOT/.find-requires <<EOF
(/usr/lib/rpm/find-requires | grep -v %{_jvmdir}/%{sdkdir} | grep -v /usr/bin/java | sed -e s,^/usr/lib64/lib,lib, | sed -e s,^/usr/lib/lib,lib,) || :
EOF
chmod 755 $RPM_BUILD_ROOT/.find-requires
# end HACK around find-requires
!);
