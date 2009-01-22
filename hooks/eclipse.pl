#!/usr/bin/perl -w

# does we need it?
#libgnomeui-2.so.0()(64bit)   is needed by libswt3-gtk2-3.3.0-alt1_5jpp1.7

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    $apprelease=$jpp->get_section('package','')->get_tag('Release');
    $apprelease=$1 if $apprelease=~/_(\d+)jpp/;

    # hack until gtk-update-icon-cache fix
    $jpp->del_section('post','platform');
    $jpp->del_section('postun','platform');

    # hack around x86 - missing %{name}-swt.install
    #$jpp->get_section('package','')->subst_if('1','0',qr'define initialize');
    #$jpp->get_section('install')->unshift_body_after('echo -n "" > %{_builddir}/%{buildsubdir}/%{name}-swt.install;'."\n",qr!-platform.install;!);

    #[exec] os.h:83:34: error: X11/extensions/XTest.h: No such file or directory
    # X11/extensions/XInput.h
    #$jpp->get_section('package','')->unshift_body('BuildRequires: xorg-xextproto-devel xorg-inputproto-devel'."\n");
    # I was lazy to search for the whole list of xorg-*proto-devel :(
    $jpp->get_section('package','')->unshift_body('BuildRequires: xorg-devel'."\n");

    # or rm %buildroot%_libdir/eclipse/plugins/org.apache.ant_*/bin/runant.py
    $jpp->get_section('package','')->unshift_body('AutoReqProv: yes,nopython'."\n");

    $jpp->get_section('package','')->unshift_body('BuildRequires: tomcat5-servlet-2.4-api tomcat5-jsp-2.0-api tomcat5-jasper'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: java-javadoc'."\n");
    $jpp->get_section('package','')->unshift_body('%define _enable_debug 1'."\n");

    # seamonkey provides mozilla too
    $jpp->get_section('package','swt')->subst(qr'Conflicts:\s*mozilla','Conflicts:     mozilla < 1.8');

# add this to debug org.eclipse.equinox.p2
#-nosplash -debug -consoleLog --launcher.suppressErrors

# eclipse-pde quick hack against osgi provides
#+ Требует: osgi(Cloudscape)
#+ Требует: osgi(org.apache.derby)
#+ Требует: osgi(org.apache.derby.core)
    $jpp->get_section('package','pde')->unshift_body('Provides: osgi(Cloudscape) osgi(org.apache.derby) osgi(org.apache.derby.core)'."\n");
    

    # for 3.4.1-12
    $jpp->get_section('package','')->subst(qr'java-1.5.0-gcj-javadoc','java-javadoc',qr'BuildRequires:');
    $jpp->get_section('package','')->subst(qr'BuildRequires: java-gcj-compat-devel','#BuildRequires: java-gcj-compat-devel');

    # misplaced in requires
    $jpp->get_section('package','')->unshift_body('
# todo: remove this 
#add_findreq_skiplist /usr/share/eclipse/plugins/org.eclipse.tomcat_*.v20070531/lib/jspapi.jar
#add_findreq_skiplist %_libdir/eclipse/swt-gtk-3.3.0.jar
#add_findreq_skiplist /usr/share/eclipse/plugins/org.junit_3.8.2.v200706111738/junit.jar
');

    # overwrite with fixed versions
    # segfault at start: -- getProgramDir() at eclipse.c(947)
    # due to a bug in %patch12
#diff eclipse-launcher-set-install-dir-and-shared-config.patch{~,}
#39c39
#< +     programDir = malloc( (_tcslen( temp + 1 )) * sizeof(_TCHAR) );
#---
#> +     programDir = malloc( (_tcslen( temp ) + 1) * sizeof(_TCHAR) );
    $jpp->copy_to_sources('eclipse-3.3.2-alt-launcher-set-install-dir-and-shared-config.patch');
    $jpp->get_section('package','')->subst(qr'%{name}-launcher-set-install-dir-and-shared-config.patch','eclipse-3.3.2-alt-launcher-set-install-dir-and-shared-config.patch');
    # it is split from eclipse-launcher-set-install-dir-and-shared-config.patch;
    # no need to apply it: our build of eclipse 3.3.2 seems to be rather stable
    # $jpp->add_patch('eclipse-3.3.2-alt-build-with-debuginfo.patch', STRIP => 0);

    # change from 3.3.2 (due to firefox 3.0?)
    $jpp->get_section('package','')->subst('BuildRequires: gecko-devel','BuildRequires: xulrunner-devel');
    $jpp->get_section('package','swt')->subst('Requires: gecko-libs >= 1.9','Requires: xulrunner');

    # ecj should not have osgi dependencies.
    $jpp->get_section('package','ecj')->push_body('AutoReq: yes, noosgi'."\n");

    # around jetty (after 3.3.0-7)
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s+jetty','BuildRequires: jetty5');
    $jpp->get_section('package','platform')->subst(qr'Requires:\s+jetty','#Requires: jetty5');
    $jpp->applied_block(
	"around jetty",
	sub {
    map {$_->subst('%{_javadir}/jetty/jetty.jar','%{_javadir}/jetty5/jetty5.jar')} 
    $jpp->get_section('prep'), 
    $jpp->get_section('build'), 
    $jpp->get_section('install');
	});
    # end around jetty 5

    $jpp->add_patch('eclipse-3.4.1-alt-as-needed.patch');
    # patch was generated with
    0 && $jpp->get_section('prep')->push_body(q{
# fixed linkage order with --as-needed
## /usr/lib/jvm/java/jre/bin/java: symbol lookup error: /usr/lib64/eclipse/configuration/org.eclipse.osgi/bundles/140/1/.cp/libswt-atk-gtk-3346.so: undefined symbol: atk_object_ref_relation_set
#        $(CC) $(LIBS) $(GNOMELIBS) -o $(GNOME_LIB) $(GNOME_OBJECTS)
find ./plugins -name 'make_linux.mak' -exec perl -i -npe 'chomp;$_=$1.$3.$2 if /^(\s+\$\(CC\))((?: \$\(.*LIBS\))+)(.+)$/;$_.="\n"' {} \;
});

    if (1) {############## TODO: MAKE THEM PATCHES AND CONTRIBUTE #############################
    $jpp->get_section('prep')->push_body(q{
#uname -p == unknown but exit code is 0 :( (alt feature :( )
find . -name build.sh -exec %__subst 's,uname -p,uname -m,' {} \;

# if enable make_xpcominit ...
subst 's!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA make_xpcominit!' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/build.sh'
subst s,XULRUNNER_INCLUDES,MOZILLA_INCLUDES, './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/make_linux.mak'
# was used for build with firefox
#subst 's,${XULRUNNER_LIBS},%_libdir/firefox/libxpcomglue.a,' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/make_linux.mak'
# used for build with xulrunner
subst 's,${XULRUNNER_LIBS},%_libdir/xulrunner-devel/sdk/lib/libxpcomglue.a,' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/make_linux.mak'

# if disable awt
# subst 's!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA!all $MAKE_GNOME $MAKE_CAIRO $MAKE_MOZILLA!' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/build.sh'
});
    }################################################### end TODO MAKE AS PATCHES


    if ('build' eq 'use openjdk instead of default') {
	$jpp->get_section('package','')->subst(qr'jpackage-1.?-compat','jpackage-generic-compat');
	$jpp->get_section('package','')->unshift_body('BuildRequires: java-1.6.0-openjdk-devel');
    } 

    # hack around added in -15 exact versions
    $jpp->get_section('package','')->subst_if(qr'-\d+jpp(?:\.\d+)?','', qr'^BuildRequires:');
    $jpp->get_section('package','platform')->subst(qr'Requires: jakarta-commons-el >= 1.0-9','Requires: jakarta-commons-el >= 1.0-alt3');
    $jpp->get_section('package','platform')->subst(qr'Requires: jakarta-commons-logging >= 1.0.4-6jpp.3','Requires: jakarta-commons-logging >= 1.1-alt2_3jpp1.7');
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5-jasper-eclipse >= 5.5.26-1.5','Requires: tomcat5-jasper-eclipse >= 5.5.26-alt1_1.1jpp');

# desktop-file-validate /usr/src/RPM/SOURCES/eclipse.desktop
#/usr/src/RPM/SOURCES/eclipse.desktop: error: value "eclipse.png" for key "Icon" in group "Desktop Entry" is an icon name with an extension, but there should be no extension as described in the Icon Theme Specification if the value is not an absolute path
#/usr/src/RPM/SOURCES/eclipse.desktop: warning: key "Encoding" in group "Desktop Entry" is deprecated
#/usr/src/RPM/SOURCES/eclipse.desktop: warning: value "Application;IDE;Development;Java;X-Red-Hat-Base;" for key "Categories" in group "Desktop Entry" contains a deprecated value "Application"
    $jpp->get_section('install')->unshift_body_before(q{%__subst 's,Icon=eclipse.png,Icon=eclipse,' %{SOURCE2}
%__subst 's,Categories=Application;,Categories=,' %{SOURCE2}
%__subst 's,X-Red-Hat-Base;,,' %{SOURCE2}
},qr'desktop-file-validate %{SOURCE2}');

    if (1) {
    #support for alt feature
    $jpp->copy_to_sources('org.altlinux.ide.feature-1.0.0.zip');
    $jpp->copy_to_sources('org.altlinux.ide.platform-3.4.1.zip');
    $jpp->applied_block(
	"support for alt feature",
	sub {
	    foreach my $section ($jpp->get_sections()) {
		$section->subst(qr'org.fedoraproject','org.altlinux');
		$section->subst(qr'Fedora Eclipse','ALT Linux Eclipse');
	    }
	});
    $jpp->get_section('prep')->push_body(q!subst s,org.fedoraproject,org.altlinux, %{SOURCE28}
!);
    }

    &replace_built_in_ant($jpp);
    &leave_built_in_lucene($jpp);
    # TODO: make the transition after 3.4.1 switch!
    #&leave_built_in_icu4j($jpp);
    &leave_built_in_jetty($jpp);

    # let them be noarches - sorry, not in 3.4.x
    #$jpp->get_section('package','jdt')->push_body("BuildArch: noarch\n");
};

sub replace_built_in_ant {
    my $jpp=shift;
    # ALT ant has extra packages, so enable them
    #################### ANT ####################
    $jpp->get_section('package','')->unshift_body_before('BuildRequires: ant-jai ant-jmf ant-stylebook'."\n", qr!BuildRequires: ant-!);
    $jpp->get_section('package','platform')->push_body('Requires: ant-jai ant-jmf ant-stylebook'."\n");
    $jpp->get_section('prep')->subst_if(qr'#ln -s %{_javadir}/ant/ant-','ln -s %{_javadir}/ant/ant-',qr'ant-(?:apache-bsf|commons-net|jai|jmf|stylebook).jar');
    $jpp->get_section('install')->subst_if(qr'#ln -s %{_javadir}/ant/ant-','ln -s %{_javadir}/ant/ant-',qr'ant-(?:apache-bsf|commons-net|jai|jmf|stylebook).jar');
    ################ END ANT ####################
}

sub leave_built_in_icu4j {
    my $jpp=shift;
    $jpp->get_section('package','')->subst_if('BuildRequires','#BuildRequires', qr'icu4j-eclipse >= 3.8.1');
    $jpp->get_section('package','rcp')->subst_if('Requires','#Requires',qr'icu4j-eclipse >= 3.8.1');
    $jpp->get_section('package','rcp')->push_body('Conflicts: icu4j-eclipse < 3.8'."\n");

    $jpp->get_section('package','')->unshift_body('%def_disable external_icu4j'."\n");
    $jpp->get_section('prep')->unshift_body_before(q{%if_enabled external_icu4j
}, qr'# link to the icu4j stuff');
    $jpp->get_section('prep')->unshift_body_after(q{%endif # external_icu4j
}, qr'ln -s \%{_libdir}/eclipse/plugins/com.ibm.icu_\*\.jar plugins/com.ibm.icu_\$ICUVERSION');
    $jpp->get_section('install')->unshift_body_before(q{%if_enabled external_icu4j
}, qr'# link to the icu4j stuff');
    $jpp->get_section('install')->unshift_body_after(q{%endif # external_icu4j
}, qr'rm plugins/com.ibm.icu_\*\.jar');
#warning: Installed (but unpackaged) file(s) found:
#    /usr/lib64/eclipse/plugins/com.ibm.icu_3.8.1.v20080530.jar
    $jpp->get_section('files','rcp')->push_body('%{_libdir}/%{name}/plugins/com.ibm.icu_*');
    # end icu4j
}

sub leave_built_in_jetty {
   my $jpp=shift;
    $jpp->get_section('package','')->unshift_body('%def_disable external_jetty'."\n");
    $jpp->get_section('prep')->unshift_body_before(q{%if_enabled external_jetty
}, qr'rm plugins/org.mortbay.jetty_');
    $jpp->get_section('prep')->unshift_body_after(q{%endif # external_jetty
}, qr'ln -s \%{_javadir}/jetty5/jetty5.jar plugins/org.mortbay.jetty_');
    $jpp->get_section('install')->unshift_body_before(q{%if_enabled external_jetty
}, qr'rm plugins/org.mortbay.jetty_');
    $jpp->get_section('install')->unshift_body_after(q{%endif # external_jetty
}, qr'ln -s \%{_javadir}/jetty5/jetty5.jar plugins/org.mortbay.jetty_');
}

sub leave_built_in_lucene {
    my $jpp=shift;
    # lucene: let it leave eclipse version
    $jpp->get_section('package','platform')->subst(qr'^Requires: lucene >= 2.3.1', '#Requires: lucene >= 2.3.1');
    $jpp->get_section('package','platform')->subst(qr'^Requires: lucene-contrib >= 2.3.1', '#Requires: lucene-contrib >= 2.3.1');
    $jpp->get_section('package','')->subst(qr'^BuildRequires: lucene >= 2.3.1', '#BuildRequires: lucene >= 2.3.1');
    $jpp->get_section('package','')->subst(qr'^BuildRequires: lucene-contrib >= 2.3.1', '#BuildRequires: lucene-contrib >= 2.3.1');
    $jpp->get_section('package','')->unshift_body('%def_disable external_lucene'."\n");
    $jpp->get_section('prep')->unshift_body_before(q{%if_enabled external_lucene
}, qr'# link to lucene');
    $jpp->get_section('prep')->unshift_body_after(q{%endif # external_lucene
}, qr'plugins/org.apache.lucene.analysis_\$LUCENEVERSION');
    $jpp->get_section('install')->unshift_body_before(q{%if_enabled external_lucene
}, qr'# link to lucene');
    $jpp->get_section('install')->unshift_body_after(q{%endif # external_lucene
}, qr'plugins/org.apache.lucene.analysis_\$LUCENEVERSION');
    # end lucene
}






__END__

#plugins/org.eclipse.core.filesystem/natives/unix/linux/Makefile:JAVA_HOME= ~/vm/sun142

# now we use theme
$jpp->get_section('package','')->subst(qr'%{name}-fedora-splash-3.[0-9].[0-9].png', '%{name}-altlinux-splash-3.3.0.png');
$jpp->copy_to_sources('eclipse-altlinux-splash-3.3.0.png');

# added in -14, removed -in -19
#$jpp->get_section('package','')->subst(qr'Requires: eclipse-rpm-editor','#Requires: eclipse-rpm-editor');

#Epoch:  1 let it be. they use Requires: with epoch :(
#$jpp->get_section('package','')->subst(qr'Epoch:\s+1', 'Epoch:  0');

# seems let it be.
#$jpp->get_section('package','ecj')->subst(qr'Obsoletes:\s*ecj', '#Obsoletes:	ecj');
#$jpp->get_section('package','ecj')->subst(qr'Provides:\s*ecj', '#Provides:	ecj');

# hack around added in -13 Obsoletes in pde (we moved to Epoch: 1
$jpp->get_section('package','pde')->subst(qr'1:3.3.0-13.fc8','0:3.3.0-alt2_13jpp5.0');

    # not in 3.4.1
    # hack around requires in spec body (they put it in for biarch reasons)
    #$jpp->get_section('package','-n libswt3-gtk2')->unshift_body('Provides: %{_libdir}/%{name}/plugins/org.eclipse.swt.gtk.linux.%{eclipse_arch}_3.3.2.v3349.jar
#'."\n");

# no more in 3.4.1
# multilib_support temporally disabled due to failed build
$jpp->get_section('package','')->unshift_body('%def_disable multilib_support'."\n");
$jpp->get_section('install')->unshift_body_before(q{%if_enabled multilib_support
}, qr'# Ensure that the zip files are the same across all builds.');
    $jpp->get_section('install')->unshift_body_after(q{%endif # multilib_support
}, qr'rm -rf \${RPM_BUILD_ROOT}/tmp');

    # present at least in 3.3.0: warning: file /usr/share/eclipse/plugins/org.eclipse.swt_3.3.0.v3346.jar is packaged into both libswt3-gtk2 and eclipse-rcp
    $jpp->get_section('files','rcp')->subst(qr'\%{_datadir}/\%{name}/plugins/org.eclipse.swt_','#%{_datadir}/%{name}/plugins/org.eclipse.swt_');

    # in rel30
    $jpp->get_section('package','')->subst(qr'java-javadoc >= 1.6.0','java-javadoc');
    $jpp->get_section('package','jdt')->subst(qr'java-javadoc >= 1.6.0','java-javadoc');

# no more fit to in 3.4.x
#    $jpp->get_section('install')->push_body(q{
## avoid warning -- useless
## shebang.req.files: executable script  not executable
#chmod 755 %buildroot/usr/bin/eclipse
## todo: symlink to ant-scripts
#chmod 755 %buildroot/usr/share/eclipse/plugins/org.apache.ant_*/bin/*
#chmod 755 %buildroot/usr/share/eclipse/buildscripts/copy-platform
#chmod 755 %buildroot/usr/share/eclipse/plugins/org.eclipse.pde.build_*/templates/package-build/prepare-build-dir.sh
#});

    # hack around requires in post / postun scripts. Do we do not need it in 3.4.1
    $jpp->get_section('package','rcp')->unshift_body('Provides: %_libdir/eclipse/configuration/config.ini'."\n");


# SUN JDK patches, deprecated in 3.4
$jpp->get_section('prep')->push_body_after(
q!
pushd plugins/org.eclipse.swt/Eclipse\ SWT\ PI/gtk/library
# /usr/lib -> /usr/lib64; deprecated as of eclipse 3.4
#sed --in-place "s:/usr/lib/:%{_libdir}/:g" build.sh
%ifarch x86_64
sed --in-place "s:-L\$(AWT_LIB_PATH):-L%{_jvmdir}/java/jre/lib/amd64:" make_linux.mak
%endif
%ifarch %ix86
sed --in-place "s:-L\$(AWT_LIB_PATH):-L%{_jvmdir}/java/jre/lib/i386:" make_linux.mak
%endif
popd
!, qr'plugins/org.junit4/junit.jar');


    if (0){ #old sun support code, deprecated in 3.4 ####################### ZERO
    # they loose JAVA_HOME :(
    $jpp->get_section('prep')->unshift_body_after(q{
find ./features -name build.sh -exec %__subst 's,javaHome="",javaHome="/usr/lib/jvm/java",' {} \;
find ./plugins \( -name build.sh -or -name Makefile \) -exec %__subst 's,JAVA_HOME \?=.*,JAVA_HOME=/usr/lib/jvm/java,' {} \;
}, qr'%setup'); # after because before zip/unzip-ing

    $jpp->get_section('prep')->push_body(q{
find ./features -name build.sh -exec %__subst 's,javaHome="",javaHome="/usr/lib/jvm/java",' {} \;
find ./plugins \( -name build.sh -or -name Makefile \) -exec %__subst 's,JAVA_HOME \?=.*,JAVA_HOME=/usr/lib/jvm/java,' {} \;

# SUN JDK support; deprecated in 3.4.1
#find ./plugins -name 'make_linux.mak' -exec %__subst 's,/usr/lib/jvm/java/jre/lib/x86_64,/usr/lib/jvm/java/jre/lib/amd64,' {} \;
#find ./plugins -name 'make_linux.mak' -exec %__subst 's,/usr/lib/jvm/java/jre/lib/i586,/usr/lib/jvm/java/jre/lib/i386,' {} \;
});
    # hack around added in -13 fix-java-home.patch (we fix it in our subst?)
    $jpp->get_section('prep')->subst(qr'^%patch26','#%patch26');
    $jpp->get_section('prep')->subst_after(qr'^sed --in-place "s/JAVA_HOME','#sed --in-place "s/JAVA_HOME',qr'# liblocalfile fixes');

    }######################### END ZERO ###########################

