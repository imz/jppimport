#!/usr/bin/perl -w

require 'set_update_menus.pl';
require 'set_target_14.pl';
# todo; set jvm 5? does not help

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: java-javadoc'."\n");
    $jpp->get_section('package','')->unshift_body('%define _enable_debug 1'."\n");

    #Epoch:  1
    $jpp->get_section('package','')->subst(qr'Epoch:\s+1', 'Epoch:  0');
    $jpp->get_section('package','')->subst(qr'^BuildRequires: icu4j-eclipse', '#BuildRequires: icu4j-eclipse');
    $jpp->get_section('package','rcp')->subst(qr'^Requires: icu4j-eclipse', '#Requires: icu4j-eclipse');
    $jpp->get_section('package','ecj')->subst(qr'Obsoletes:\s*ecj', '#Obsoletes:	ecj');
    $jpp->get_section('package','ecj')->subst(qr'Provides:\s*ecj', '#Provides:	ecj');
    $jpp->get_section('package','')->subst(qr'%{name}-fedora-splash-3.[0-9].[0-9].png', '%{name}-altlinux-splash-3.3.0.png');
    $jpp->copy_to_sources('eclipse-altlinux-splash-3.3.0.png');

    $appversion=$jpp->get_section('package','')->get_tag('Version');
    if ($appversion eq '3.2.2') {
	$jpp->get_section('prep')->unshift_body_before(q!%__subst 's,ant.java.version\}" arg2="1.4"/>,ant.java.version}" arg2="1.7"/>,' build.xml
%__subst 's,compiler="javac1.3",,' build.xml
!,qr!^ant .*eclipseProjects$!);

#	$jpp->get_section('build')->subst(qr'ant -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 build.update.jar', 'ant build.update.jar');
    } elsif ($appversion eq '3.3.0') {
	print STDERR "in appversion: $appversion\n";

	# bootstrap hack around icu4j w/o eclipse
	$jpp->get_section('prep')->subst(qr'rm plugins/com.ibm.icu_3.6.1.v20070417.jar', 'mv plugins/com.ibm.icu_3.6.1.v20070417.jar plugins/com.ibm.icu_3.6.1.v20070417.jar.no');
	$jpp->get_section('prep')->push_body('
rm plugins/com.ibm.icu_3.6.1.v20070417.jar
mv plugins/com.ibm.icu_3.6.1.v20070417.jar.no plugins/com.ibm.icu_3.6.1.v20070417.jar
');

	# segfault at start: -- getProgramDir() at eclipse.c(947)
	# due to a bug in %patch12
#diff eclipse-launcher-set-install-dir-and-shared-config.patch{~,}
#39c39
#< +     programDir = malloc( (_tcslen( temp + 1 )) * sizeof(_TCHAR) );
#---
#> +     programDir = malloc( (_tcslen( temp ) + 1) * sizeof(_TCHAR) );
	# overwrite with fixed version
	# FIXED in 30
	#$jpp->copy_to_sources('eclipse-launcher-set-install-dir-and-shared-config.patch');
	# in rel30
	$jpp->get_section('package','')->subst(qr'java-javadoc >= 1.6.0','java-javadoc');
	$jpp->get_section('package','jdt')->subst(qr'java-javadoc >= 1.6.0','java-javadoc');

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
    }

    # multilib_support temporally disabled due to failed build
    $jpp->get_section('package','')->unshift_body('%def_disable multilib_support'."\n");
    $jpp->get_section('install')->unshift_body_before(q{%if_enabled multilib_support
}, qr'# Ensure that the zip files are the same across all builds.');
    $jpp->get_section('install')->unshift_body_after(q{%endif # multilib_support
}, qr'rm -rf \${RPM_BUILD_ROOT}/tmp');


    # they loose JAVA_HOME :(
# the issue with zip/unzip is fixed in 30
#    $jpp->get_section('prep')->unshift_body_after(q{
#find ./features -name build.sh -exec %__subst 's,javaHome="",javaHome="/usr/lib/jvm/java",' {} \;
#find ./plugins \( -name build.sh -or -name Makefile \) -exec %__subst 's,JAVA_HOME \?=.*,JAVA_HOME=/usr/lib/jvm/java,' {} \;
#}, qr'%setup'); # after because before zip/unzip-ing
    $jpp->get_section('prep')->push_body(q{
find ./features -name build.sh -exec %__subst 's,javaHome="",javaHome="/usr/lib/jvm/java",' {} \;
find ./plugins \( -name build.sh -or -name Makefile \) -exec %__subst 's,JAVA_HOME \?=.*,JAVA_HOME=/usr/lib/jvm/java,' {} \;
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

__END__
