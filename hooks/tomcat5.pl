#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';
require 'windows-thumbnail-database-in-package.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # due to ecj :(
    $jpp->get_section('package')->subst(qr'jpackage-compat','jpackage-1.6-compat');
    
    # TODO: write proper tomcat5-5.5.init!
    # as a hack, an old version is taken
    $jpp->copy_to_sources('tomcat5-5.5.init');
    $jpp->get_section('package','')->subst_if('Requires','#Requires',qr'/lib/lsb/init-functions');

#warning: file /usr/bin/jasper5-setclasspath.sh is packaged into both tomcat5 and tomcat5-jasper
#warning: file /usr/bin/jasper5.sh is packaged into both tomcat5 and tomcat5-jasper
#warning: file /usr/bin/jspc5.sh is packaged into both tomcat5 and tomcat5-jasper
    $jpp->get_section('files','')->push_body(q'%exclude %_bindir/jasper5-setclasspath.sh
%exclude %_bindir/jasper5.sh
%exclude %_bindir/jspc5.sh
');


    # BUG to report (5.5.25 1-fc9) too
    $jpp->get_section('build')->subst(qr'%{java.home}','%{java_home}');

    # fedora specific (5.5.25 1-fc9)
    $jpp->get_section('package','')->push_body('BuildRequires: zip'."\n");

    # to make them 1.4, not 1.5
    $jpp->get_section('build')->subst(qr'ant\s+-Dservletapi.build="build"','ant -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 -Dservletapi.build="build"');

    # additional hacks due to ecj of java6; REPLACE WITH TARGET 1.5 everywhere after get rid of 1.4
    $jpp->get_section('build')->subst(qr'compiler="modern" javadoc','compiler="modern" -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 javadoc', qr'ant ');
    $jpp->get_section('build')->subst(qr'java_home}" build','java_home}" -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5 build', qr'ant ');
    $jpp->get_section('install')->subst(qr'ant\s+-D','ant -Dant.build.javac.source=1.4 -D');
    # end fedora specific 

    $jpp->get_section('package','server-lib')->push_body('Requires: jaf javamail'."\n");

    $jpp->get_section('package','')->push_body('Provides: %{name}-server = %{version}-%{release}'."\n");
    $jpp->get_section('package','')->push_body('Obsoletes: %{name}-server <= 5.5.16-alt1.1'."\n");
    $jpp->get_section('package','admin-webapps')->push_body('Provides: %{name}-admin-webapps = %{version}-%{release}'."\n");
    $jpp->raw_rename_section('admin-webapps','webapps-admin');
    # #14415
    $jpp->get_section('description','')->subst(qr'We invite you to participate in this open development project. To','');
    $jpp->get_section('description','')->subst(qr'learn more about getting involved, click here.','');


    $jpp->get_section('pre')->subst(qr'-[gu] %\{tcuid\}','');

    # a part of #%post_service %name that is not implemented there:
    # condrestart on upgrade 
    $jpp->get_section('post')->push_body('/sbin/service %name condrestart'."\n");

    # merge from old alt tomcat5:
    # do we really need all of this?
    $jpp->get_section('post','webapps')->push_body(q'/sbin/service %name condrestart
');

    $jpp->get_section('post','webapps-admin')->push_body(q'/sbin/service %name condrestart
');

    $jpp->get_section('preun','webapps')->push_body(q'[ $1 != 0 ] || /sbin/service %name condrestart
');

    $jpp->get_section('preun','webapps-admin')->push_body(q'[ $1 != 0 ] || /sbin/service %name condrestart
');

    # todo: make an extension?
    $jpp->get_section('install')->push_body('mkdir -p $RPM_BUILD_ROOT/%_altdir/
cat >>$RPM_BUILD_ROOT/%_altdir/servletapi_%{name}<<EOF
%{_javadir}/servletapi.jar	%{_javadir}/%{name}-servlet-2.4-api-%{version}.jar	20400
EOF
');
    $jpp->get_section('files','servlet-2.4-api')->push_body('%_altdir/servletapi_*'."\n");
    $jpp->get_section('install')->push_body(
q'
%triggerpostun -- tomcat5-server <= 5.5.16-alt1.1
for i in common/classes common/endorsed common/lib shared/classes shared/lib webapps; do
if [ -d /usr/lib/tomcat5/$i ]; then
    echo "upgrade: moving old /usr/lib/tomcat5/$i to /var/lib/tomcat5/$i"
    mv -f /usr/lib/tomcat5/$i/* /var/lib/tomcat5/$i/
fi
done || :
');

}
__DATA__
todo: verify logrotate
    # break build with java 1.5.0
    #Patch19: %{name}-%{majversion}-connectors-util-build.patch
    #$jpp->get_section('prep')->subst(qr'%patch19 -b .p19','#%patch19 -b .p19');
    #Patch21: %{name}-%{majversion}-acceptlangheader.patch
    #$jpp->get_section('prep')->subst(qr'%patch21 -b .p21','#%patch21 -b .p21');

