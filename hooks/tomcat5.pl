#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;

    # for servletapi 5
    #$jpp->get_section('package','servlet-2.4-api')->push_body('Provides: servletapi5 = 0:%{version}'."\n");

    # BUG to report
    $jpp->get_section('build')->subst(qr'%{java.home}','%{java_home}');

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

$jpp->get_section('pre')->subst(qr'-[gu] %\{tcuid\}','');

# do not apply; let strange admins do it themselves
# warn; out of %endif
# does not work with warning 'user tomcat exists'
#$jpp->get_section('pre')->push_body(q'useradd -G apache tomcat || :'."\n");
# adapter
#%_sbindir/groupadd -r -f tomcat -g `id -g %tomcat_user` -o >/dev/null 2>&1 ||:
#%_sbindir/useradd -r -g %tomcat_group -c "Tomcat server" -d %tomcat_home -s /dev/null -n %tomcat_user \
#        >/dev/null 2>&1 ||:

# alt
#%_sbindir/groupadd -r -f %tomcat_group >/dev/null 2>&1 ||:
#%_sbindir/useradd -r -g %tomcat_group -c "Tomcat server" -d %tomcat_home -s /dev/null -n %tomcat_user \
#        >/dev/null 2>&1 ||:

# Add the "tomcat" user and group
# we need a shell to be able to use su - later
#%{_sbindir}/groupadd -g %{tcuid} -r tomcat 2> /dev/null || :
#%{_sbindir}/useradd -c "Apache Tomcat" -u %{tcuid} -g tomcat \
#    -s /bin/sh -r -d %{homedir} tomcat 2> /dev/null || :

# merge from old alt tomcat5:
# do we really need all of this?
$jpp->get_section('post')->push_body(q'
%post_service %name
');

$jpp->get_section('post','webapps')->push_body(q'
/sbin/service %name condrestart
');


$jpp->get_section('post','webapps-admin')->push_body(q'
/sbin/service %name condrestart
');

$jpp->get_section('preun')->push_body(q'
%preun_service %name
');

$jpp->get_section('preun','webapps')->push_body(q'
[ $1 != 0 ] || /sbin/service %name condrestart
');

$jpp->get_section('preun','webapps-admin')->push_body(q'
[ $1 != 0 ] || /sbin/service %name condrestart
');

}
__DATA__
todo: logrotate
