#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;

    # BUG to report (5.5.25 1-fc9) too
    $jpp->get_section('build')->subst(qr'%{java.home}','%{java_home}');

    # fedora specific (5.5.25 1-fc9)
    $jpp->get_section('package','')->push_body('BuildRequires: zip'."\n");

    # break build with java 1.5.0
    #Patch19: %{name}-%{majversion}-connectors-util-build.patch
    $jpp->get_section('prep')->subst(qr'%patch19 -b .p19','#%patch19 -b .p19');
    #$jpp->get_section('prep')->subst(qr'%patch20 -b .p20','#%patch20 -b .p20');
    #Patch21: %{name}-%{majversion}-acceptlangheader.patch
    $jpp->get_section('prep')->subst(qr'%patch21 -b .p21','#%patch21 -b .p21');

    # to make them 1.4, not 1.5
    $jpp->get_section('build')->subst(qr'ant\s+-Dservletapi.build="build"','ant -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 -Dservletapi.build="build"');
    # end fedora specific 

    $jpp->get_section('package','server-lib')->push_body('Requires: jaf javamail'."\n");

    $jpp->get_section('package','')->push_body('Provides: %{name}-server = %{version}-%{release}'."\n");
    $jpp->get_section('package','')->push_body('Obsoletes: %{name}-server <= 5.5.16-alt1.1'."\n");
    $jpp->get_section('package','admin-webapps')->push_body('Provides: %{name}-admin-webapps = %{version}-%{release}'."\n");
    $jpp->raw_rename_section('admin-webapps','webapps-admin');
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

}
__DATA__
todo: verify logrotate
