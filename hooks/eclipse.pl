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

#    $jpp->get_section('package','')->unshift_body('BuildRequires: eclipse-bootstrap-bundle'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: tomcat5-servlet-2.4-api tomcat5-jsp-2.0-api tomcat5-jasper'."\n");

    $jpp->get_section('package','')->unshift_body('BuildRequires: java-javadoc'."\n");
    $jpp->get_section('package','')->unshift_body('%define _enable_debug 1'."\n");

    # misplaced in requires
    $jpp->get_section('package','')->unshift_body('
%add_findreq_skiplist /usr/share/eclipse/plugins/org.eclipse.tomcat_4.1.230.v20070531/lib/jspapi.jar
%add_findreq_skiplist /usr/lib64/eclipse/swt-gtk-3.3.0.jar
');   

    # hack around requires in post / postun scripts
    $jpp->get_section('package','rcp')->unshift_body('Provides: /usr/lib64/eclipse/configuration/config.ini'."\n");

    # hack around requires in post / postun scripts
    $jpp->get_section('package','-n libswt3-gtk2')->unshift_body('Provides: /usr/lib64/eclipse/plugins/org.eclipse.swt.gtk.linux.x86_64_3.3.0.v3346.jar'."\n");

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


# the issue with zip/unzip is fixed in 30
    if ($apprelease < 30) {
    # they loose JAVA_HOME :(
    $jpp->get_section('prep')->unshift_body_after(q{
find ./features -name build.sh -exec %__subst 's,javaHome="",javaHome="/usr/lib/jvm/java",' {} \;
find ./plugins \( -name build.sh -or -name Makefile \) -exec %__subst 's,JAVA_HOME \?=.*,JAVA_HOME=/usr/lib/jvm/java,' {} \;
}, qr'%setup'); # after because before zip/unzip-ing
    }

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
#subst 's!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA make_xpcominit!' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/build.sh'

# if disable awt
subst 's!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA!all $MAKE_GNOME $MAKE_CAIRO $MAKE_MOZILLA!' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/build.sh'



#subst s,XULRUNNER_INCLUDES,MOZILLA_INCLUDES, './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/make_linux.mak'
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


# desktop-file-validate /usr/src/RPM/SOURCES/eclipse.desktop
#/usr/src/RPM/SOURCES/eclipse.desktop: error: value "eclipse.png" for key "Icon" in group "Desktop Entry" is an icon name with an extension, but there should be no extension as described in the Icon Theme Specification if the value is not an absolute path
#/usr/src/RPM/SOURCES/eclipse.desktop: warning: key "Encoding" in group "Desktop Entry" is deprecated
#/usr/src/RPM/SOURCES/eclipse.desktop: warning: value "Application;IDE;Development;Java;X-Red-Hat-Base;" for key "Categories" in group "Desktop Entry" contains a deprecated value "Application"
    $jpp->get_section('install')->unshift_body_before(q{%__subst 's,Icon=eclipse.png,Icon=eclipse,' %{SOURCE2}
%__subst 's,Categories=Application;,Categories=,' %{SOURCE2}
%__subst 's,X-Red-Hat-Base;,,' %{SOURCE2}
},qr'desktop-file-validate %{SOURCE2}');



}
#plugins/org.eclipse.core.filesystem/natives/unix/linux/Makefile:JAVA_HOME= ~/vm/sun142

### TODO:!!! fix /usr/src/RPM/BUILD/eclipse-3.3.0/plugins/org.eclipse.equinox.http.jetty/build.xml
#to use our jetty5!!!

__END__
	# bootstrap hack around icu4j w/o eclipse
    $jpp->get_section('package','')->subst(qr'^BuildRequires: icu4j-eclipse', '#BuildRequires: icu4j-eclipse');
    $jpp->get_section('package','rcp')->subst(qr'^Requires: icu4j-eclipse', '#Requires: icu4j-eclipse');

	$jpp->get_section('prep')->subst(qr'rm plugins/com.ibm.icu_3.6.1.v20070417.jar', 'mv plugins/com.ibm.icu_3.6.1.v20070417.jar plugins/com.ibm.icu_3.6.1.v20070417.jar.no');
	$jpp->get_section('prep')->push_body('
rm plugins/com.ibm.icu_3.6.1.v20070417.jar
mv plugins/com.ibm.icu_3.6.1.v20070417.jar.no plugins/com.ibm.icu_3.6.1.v20070417.jar
');

	# around jetty
	$jpp->get_section('package','')->subst(qr'BuildRequires:\s+jetty','#BuildRequires: jetty');
	$jpp->get_section('package','platform')->subst(qr'Requires:\s+jetty','#Requires: jetty');
	$jpp->get_section('prep')->subst(qr'rm plugins/org.mortbay.jetty_\$JETTYPLUGINVERSION', '#rm plugins/org.mortbay.jetty_$JETTYPLUGINVERSION');
	$jpp->get_section('prep')->subst(qr'ln -s \%{_javadir}/jetty/jetty.jar plugins/org.mortbay.jetty_\$JETTYPLUGINVERSION', '#ln -s %{_javadir}/jetty/jetty.jar plugins/org.mortbay.jetty_$JETTYPLUGINVERSION');
	$jpp->get_section('install')->subst(qr'rm plugins/org.mortbay.jetty_\$JETTYPLUGINVERSION', '#rm plugins/org.mortbay.jetty_$JETTYPLUGINVERSION');
	$jpp->get_section('install')->subst(qr'ln -s \%{_javadir}/jetty/jetty.jar plugins/org.mortbay.jetty_\$JETTYPLUGINVERSION', '#ln -s %{_javadir}/jetty/jetty.jar plugins/org.mortbay.jetty_$JETTYPLUGINVERSION');


	# no jasper plugin in our tomcat
	$jpp->get_section('package','')->subst(qr'jasper-eclipse','jasper');
	$jpp->get_section('package','platform')->subst(qr'jasper-eclipse','jasper');
	$jpp->get_section('prep')->unshift_body_before(q!%if 0
!,qr'# link to jasper');
	$jpp->get_section('prep')->unshift_body_after(q!%endif
!,qr'   plugins/org.apache.jasper_5.5.17.v200706111724.jar');
	$jpp->get_section('install')->unshift_body_before(q!%if 0
!,qr'# link to jasper');
	$jpp->get_section('install')->unshift_body_after(q!%endif
!,qr'rm plugins/org.apache.jasper_5.5.17.v200706111724.jar');

	# hack around lucene-contrib
	$jpp->get_section('package','')->subst(qr'BuildRequires:\s+lucene-contrib','#BuildRequires: lucene-contrib');
	$jpp->get_section('package','platform')->subst(qr'Requires:\s+lucene-contrib','#Requires: lucene-contrib');
	$jpp->get_section('prep')->unshift_body_before(q!%if 0
!,qr'# link to lucene');
	$jpp->get_section('prep')->unshift_body_after(q!%endif
!,qr'ln -s \%{_javadir}/lucene-contrib/lucene-analyzers.jar plugins/org.apache.lucene.analysis_1.9.1.v200706181610.jar');
	$jpp->get_section('install')->unshift_body_before(q!%if 0
!,qr'# link to lucene');
	$jpp->get_section('install')->unshift_body_after(q!%endif
!,qr'ln -s \%{_javadir}/lucene-contrib/lucene-analyzers.jar plugins/org.apache.lucene.analysis_1.9.1.v200706181610.jar');


#########################
    $appversion=$jpp->get_section('package','')->get_tag('Version');
    print STDERR "in appversion: $appversion\n";

    if ($appversion eq '3.2.2') {
	$jpp->get_section('prep')->unshift_body_before(q!%__subst 's,ant.java.version\}" arg2="1.4"/>,ant.java.version}" arg2="1.7"/>,' build.xml
%__subst 's,compiler="javac1.3",,' build.xml
!,qr!^ant .*eclipseProjects$!);

#	$jpp->get_section('build')->subst(qr'ant -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 build.update.jar', 'ant build.update.jar');
    } elsif ($appversion eq '3.3.0') {


#######################################################


ln -s %{_javadir}/lucene.jar plugins/org.apache.lucene_1.9.1.v200706111724.jar
ln -s %{_javadir}/lucene-contrib/lucene-analyzers.jar plugins/org.apache.lucene.analysis_1.9.1.v200706181610.jar
