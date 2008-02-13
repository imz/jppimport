require 'set_add_jspapi_dep.pl';
require 'set_with_coreonly.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->disable_package('webapps-tomcat3');
    $jpp->get_section('install')->push_body("rm -rf \$RPM_BUILD_ROOT/var/lib/tomcat3\n");
    # not to lead into temptation shell.req
    $jpp->get_section('install')->push_body("rm -rf \$RPM_BUILD_ROOT/var/lib/tomcat?/webapps/struts-documentation/download.cgi\n");

    # this struts do require commons-validator 1.1.x
    # below is a part of changes to support 1.2 :(
    $jpp->get_section('prep')->push_body(q!
for i in `grep -rl org.apache.commons.validator.ValidatorUtil .`; do \
%__subst s,org.apache.commons.validator.ValidatorUtil,org.apache.commons.validator.util.ValidatorUtils, $i; done
for i in `grep -rl ValidatorUtil.replace .`; do \
%__subst s,ValidatorUtil.replace,ValidatorUtils.replace, $i; done
!)

}
__END__
http://wiki.apache.org/struts/StrutsUpgradeNotes11to124
