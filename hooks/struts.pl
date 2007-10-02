require 'set_add_jspapi_dep.pl';
require 'set_with_coreonly.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->disable_package('webapps-tomcat3');
    $jpp->get_section('install')->push_body("rm -rf \$RPM_BUILD_ROOT/var/lib/tomcat3\n");
    # not to lead into temptation shell.req
    $jpp->get_section('install')->push_body("rm -rf \$RPM_BUILD_ROOT/var/lib/tomcat?/webapps/struts-documentation/download.cgi\n");

    
}
