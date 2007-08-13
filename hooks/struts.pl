require 'set_add_jspapi_dep.pl';
require 'set_with_coreonly.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->disable_package('webapps-tomcat3');
}
