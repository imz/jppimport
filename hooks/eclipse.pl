#!/usr/bin/perl -w

require 'set_update_menus.pl';
#require 'set_target_14.pl';
# todo; set jvm 5? does not help?

# does we need it?
#libgnomeui-2.so.0()(64bit)   is needed by libswt3-gtk2-3.3.0-alt1_5jpp1.7

$spechook = sub {
    my ($jpp, $alt) = @_;

    $apprelease=$jpp->get_section('package','')->get_tag('Release');
    $apprelease=$1 if $apprelease=~/_(\d+)jpp/;

    # note: disabled in 16 and enabled in 18 again
    if ($apprelease < 18) {
	$jpp->get_section('prep')->subst_after(qr'%if\s+%{gcj_support}','%if_without java6', qr'# remove jdt.apt.pluggable.core, jdt.compiler.tool and org.eclipse.jdt.compiler.apt as they require a JVM that supports Java 1.6');
	$jpp->get_section('prep')->subst_after(qr'%if\s+%{gcj_support}','%if_without java6', qr'the ia64 strings with ppc64');
	$jpp->get_section('build')->subst_after(qr'%if\s+%{gcj_support}','%if_without java6', qr'# Build the rest of Eclipse');
	$jpp->get_section('files','jdt')->subst(qr'%else','%endif'."\n"."%if_with java6");
    }

    # disable java-1.6.0 code
    $jpp->get_section('package','')->unshift_body('%def_without java6'."\n");

#    $jpp->get_section('package','')->unshift_body('BuildRequires: eclipse-bootstrap-bundle'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: tomcat5-servlet-2.4-api tomcat5-jsp-2.0-api tomcat5-jasper'."\n");

    $jpp->get_section('package','')->unshift_body('BuildRequires: java-javadoc'."\n");
    $jpp->get_section('package','')->unshift_body('%define _enable_debug 1'."\n");

    # misplaced in requires
    $jpp->get_section('package','')->unshift_body('
# todo: remove this 
%add_findreq_skiplist /usr/share/eclipse/plugins/org.eclipse.tomcat_4.1.230.v20070531/lib/jspapi.jar
%add_findreq_skiplist %_libdir/eclipse/swt-gtk-3.3.0.jar
%add_findreq_skiplist /usr/share/eclipse/plugins/org.junit_3.8.2.v200706111738/junit.jar
');

    # hack around requires in post / postun scripts
    $jpp->get_section('package','rcp')->unshift_body('Provides: %_libdir/eclipse/configuration/config.ini'."\n");

    # hack around requires in spec body (they put it in for biarch reasons
    $jpp->get_section('package','-n libswt3-gtk2')->unshift_body('Provides: %{_libdir}/%{name}/plugins/org.eclipse.swt.gtk.linux.%{eclipse_arch}_3.3.0.v3346.jar'."\n");

    #Epoch:  1
    $jpp->get_section('package','')->subst(qr'Epoch:\s+1', 'Epoch:  0');
    $jpp->get_section('package','ecj')->subst(qr'Obsoletes:\s*ecj', '#Obsoletes:	ecj');
    $jpp->get_section('package','ecj')->subst(qr'Provides:\s*ecj', '#Provides:	ecj');
    $jpp->get_section('package','')->subst(qr'%{name}-fedora-splash-3.[0-9].[0-9].png', '%{name}-altlinux-splash-3.3.0.png');
    $jpp->copy_to_sources('eclipse-altlinux-splash-3.3.0.png');

    # overwrite with fixed versions
    # segfault at start: -- getProgramDir() at eclipse.c(947)
    # due to a bug in %patch12
#diff eclipse-launcher-set-install-dir-and-shared-config.patch{~,}
#39c39
#< +     programDir = malloc( (_tcslen( temp + 1 )) * sizeof(_TCHAR) );
#---
#> +     programDir = malloc( (_tcslen( temp ) + 1) * sizeof(_TCHAR) );
    $jpp->copy_to_sources('eclipse-3.3.0-alt-launcher-set-install-dir-and-shared-config.patch');
    # double free bug still exist
    $jpp->copy_to_sources('eclipse-3.3.0-alt-launcher-double-free-bug.patch');
    $jpp->get_section('package','')->subst(qr'%{name}-launcher-double-free-bug.patch','eclipse-3.3.0-alt-launcher-double-free-bug.patch');
    $jpp->get_section('package','')->subst(qr'%{name}-launcher-set-install-dir-and-shared-config.patch','eclipse-3.3.0-alt-launcher-set-install-dir-and-shared-config.patch');



    # in rel30
    $jpp->get_section('package','')->subst(qr'java-javadoc >= 1.6.0','java-javadoc');
    $jpp->get_section('package','jdt')->subst(qr'java-javadoc >= 1.6.0','java-javadoc');


    # around jetty (after 3.3.0-7)
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s+jetty','BuildRequires: jetty5');
    $jpp->get_section('package','platform')->subst(qr'Requires:\s+jetty','#Requires: jetty5');
    map {$_->subst('%{_javadir}/jetty/jetty.jar','%{_javadir}/jetty5/jetty5.jar')} 
    $jpp->get_section('prep'), 
    $jpp->get_section('build'), 
    $jpp->get_section('install');
    # end around jetty 5

    # multilib_support temporally disabled due to failed build
    $jpp->get_section('package','')->unshift_body('%def_disable multilib_support'."\n");
    $jpp->get_section('install')->unshift_body_before(q{%if_enabled multilib_support
}, qr'# Ensure that the zip files are the same across all builds.');
    $jpp->get_section('install')->unshift_body_after(q{%endif # multilib_support
}, qr'rm -rf \${RPM_BUILD_ROOT}/tmp');

    # they loose JAVA_HOME :(
    $jpp->get_section('prep')->unshift_body_after(q{
find ./features -name build.sh -exec %__subst 's,javaHome="",javaHome="/usr/lib/jvm/java",' {} \;
find ./plugins \( -name build.sh -or -name Makefile \) -exec %__subst 's,JAVA_HOME \?=.*,JAVA_HOME=/usr/lib/jvm/java,' {} \;
}, qr'%setup'); # after because before zip/unzip-ing

    $jpp->get_section('prep')->push_body(q{
find ./features -name build.sh -exec %__subst 's,javaHome="",javaHome="/usr/lib/jvm/java",' {} \;
find ./plugins \( -name build.sh -or -name Makefile \) -exec %__subst 's,JAVA_HOME \?=.*,JAVA_HOME=/usr/lib/jvm/java,' {} \;

#uname -p == unknown but exit code is 0 :( (alt feature :( )
find . -name build.sh -exec %__subst 's,uname -p,uname -m,' {} \;

# SUN JDK support
find ./plugins -name 'make_linux.mak' -exec %__subst 's,/usr/lib/jvm/java/jre/lib/x86_64,/usr/lib/jvm/java/jre/lib/amd64,' {} \;
find ./plugins -name 'make_linux.mak' -exec %__subst 's,/usr/lib/jvm/java/jre/lib/i586,/usr/lib/jvm/java/jre/lib/i386,' {} \;

# fixed linkage order with --as-needed
## /usr/lib/jvm/java/jre/bin/java: symbol lookup error: /usr/lib64/eclipse/configuration/org.eclipse.osgi/bundles/140/1/.cp/libswt-atk-gtk-3346.so: undefined symbol: atk_object_ref_relation_set
#        $(CC) $(LIBS) $(GNOMELIBS) -o $(GNOME_LIB) $(GNOME_OBJECTS)
find ./plugins -name 'make_linux.mak' -exec perl -i -npe 'chomp;$_=$1.$3.$2 if /^(\s+\$\(CC\))((?: \$\(.*LIBS\))+)(.+)$/;$_.="\n"' {} \;

# if enable make_xpcominit ...
subst 's!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA make_xpcominit!' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/build.sh'
subst s,XULRUNNER_INCLUDES,MOZILLA_INCLUDES, './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/make_linux.mak'
subst 's,${XULRUNNER_LIBS},%_libdir/firefox/libxpcomglue.a,' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/make_linux.mak'

# if disable awt
# subst 's!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA!all $MAKE_GNOME $MAKE_CAIRO $MAKE_MOZILLA!' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/build.sh'
});

    $jpp->get_section('install')->push_body(q{
# avoid warning -- useless
# shebang.req.files: executable script  not executable
chmod 755 %buildroot/usr/bin/eclipse
# todo: symlink to ant
#chmod 755 %buildroot/usr/share/eclipse/plugins/org.apache.ant_*/bin/*
chmod 755 %buildroot/usr/share/eclipse/buildscripts/copy-platform
chmod 755 %buildroot/usr/share/eclipse/plugins/org.eclipse.pde.build_*/templates/package-build/prepare-build-dir.sh
});

    # hack around added in -13 Obsoletes in pde
    $jpp->get_section('package','pde')->subst(qr'1:3.3.0-13.fc8','0:3.3.0-alt2_13jpp5.0');


    # hack around added in -13 fix-java-home.patch (we fix it in our subst?)
    $jpp->get_section('prep')->subst(qr'^%patch26','#%patch26');
    $jpp->get_section('prep')->subst_after(qr'^sed --in-place "s/JAVA_HOME','#sed --in-place "s/JAVA_HOME',qr'# liblocalfile fixes');

$jpp->get_section('prep')->push_body_after(
q!
pushd plugins/org.eclipse.swt/Eclipse\ SWT\ PI/gtk/library
# /usr/lib -> /usr/lib64
sed --in-place "s:/usr/lib/:%{_libdir}/:g" build.sh
%ifarch x86_64
sed --in-place "s:-L\$(AWT_LIB_PATH):-L%{_jvmdir}/java/jre/lib/amd64:" make_linux.mak
%endif
%ifarch %ix86
sed --in-place "s:-L\$(AWT_LIB_PATH):-L%{_jvmdir}/java/jre/lib/i386:" make_linux.mak
%endif
popd
!, qr'plugins/org.junit4/junit.jar');

    # added in -14
    $jpp->get_section('package','')->subst(qr'Requires: eclipse-rpm-editor','#Requires: eclipse-rpm-editor');

    # seamonkey provides mozilla
    $jpp->get_section('package','-n %{libname}-gtk2')->subst(qr'Conflicts:\s*mozilla','#Conflicts:     mozilla');

    # hack around added in -15 exact versions
    $jpp->get_section('package','')->subst_if(qr'-\d+jpp(?:\.\d+)?','', qr'^BuildRequires:');
    $jpp->get_section('package','platform')->subst(qr'Requires: jakarta-commons-el >= 1.0-8jpp','Requires: jakarta-commons-el >= 1.0-alt1_8.2jpp1.7');
    $jpp->get_section('package','platform')->subst(qr'Requires: jakarta-commons-logging >= 1.0.4-6jpp.3','Requires: jakarta-commons-logging >= 1.1-alt2_3jpp1.7');
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5 >= 5.5.23-9jpp.4','Requires: tomcat5 >= 5.5.25-alt1_1.1jpp');
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5-jasper-eclipse >= 5.5.23-9jpp.4','Requires: tomcat5-jasper-eclipse >= 5.5.25-alt1_1.1jpp');
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5-servlet-2.4-api >= 5.5.23-9jpp.4','Requires: tomcat5-servlet-2.4-api >= 5.5.25-alt1_1.1jpp');
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5-jsp-2.0-api >= 5.5.23-9jpp.4','Requires: tomcat5-jsp-2.0-api >= 5.5.25-alt1_1.1jpp');


# desktop-file-validate /usr/src/RPM/SOURCES/eclipse.desktop
#/usr/src/RPM/SOURCES/eclipse.desktop: error: value "eclipse.png" for key "Icon" in group "Desktop Entry" is an icon name with an extension, but there should be no extension as described in the Icon Theme Specification if the value is not an absolute path
#/usr/src/RPM/SOURCES/eclipse.desktop: warning: key "Encoding" in group "Desktop Entry" is deprecated
#/usr/src/RPM/SOURCES/eclipse.desktop: warning: value "Application;IDE;Development;Java;X-Red-Hat-Base;" for key "Categories" in group "Desktop Entry" contains a deprecated value "Application"
    $jpp->get_section('install')->unshift_body_before(q{%__subst 's,Icon=eclipse.png,Icon=eclipse,' %{SOURCE2}
%__subst 's,Categories=Application;,Categories=,' %{SOURCE2}
%__subst 's,X-Red-Hat-Base;,,' %{SOURCE2}
},qr'desktop-file-validate %{SOURCE2}');

    #TODO: support for alt feature
    $jpp->copy_to_sources('org.altlinux.ide.feature-1.0.0.zip');
    $jpp->copy_to_sources('org.altlinux.ide.platform-3.3.0.zip');
    foreach my $section (@{$jpp->get_sections()}) {
	$section->subst(qr'org.fedoraproject','org.altlinux');
    }
    $jpp->get_section('package','')->subst_if(qr'\.\d+.zip','.zip',qr'^Source4:');

}

#plugins/org.eclipse.core.filesystem/natives/unix/linux/Makefile:JAVA_HOME= ~/vm/sun142
__END__
