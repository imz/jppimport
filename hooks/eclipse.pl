#!/usr/bin/perl -w

require 'set_target_14.pl';
require 'set_update_menus.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: java-javadoc'."\n");
    #Epoch:  1
    $jpp->get_section('package','')->subst(qr'Epoch:\s+1', 'Epoch:  0');
    $jpp->get_section('package','')->subst(qr'^BuildRequires: icu4j-eclipse', '#BuildRequires: icu4j-eclipse');
    $jpp->get_section('package','rcp')->subst(qr'^Requires: icu4j-eclipse', '#Requires: icu4j-eclipse');
    $jpp->get_section('package','ecj')->subst(qr'Obsoletes:\s*ecj', '#Obsoletes:	ecj');
    $jpp->get_section('package','ecj')->subst(qr'Provides:\s*ecj', '#Provides:	ecj');
    $jpp->get_section('package','')->subst(qr'%{name}-fedora-splash-3.3.0.png', '%{name}-altlinux-splash-3.3.0.png');
    $jpp->copy_to_sources('eclipse-altlinux-splash-3.3.0.png');

    # bootstrap hack around icu4j w/o eclipse
    $jpp->get_section('prep')->subst(qr'rm plugins/com.ibm.icu_3.6.1.v20070417.jar', 'mv plugins/com.ibm.icu_3.6.1.v20070417.jar plugins/com.ibm.icu_3.6.1.v20070417.jar.no');
    $jpp->get_section('prep')->push_body('
rm plugins/com.ibm.icu_3.6.1.v20070417.jar
mv plugins/com.ibm.icu_3.6.1.v20070417.jar.no plugins/com.ibm.icu_3.6.1.v20070417.jar
');

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
