#!/usr/bin/perl -w

push @SPECHOOKS, \&set_add_jspapi_dep;

# hack due to our tomcat servletapi not require jspapi?
# todo: chack and fix

sub set_add_jspapi_dep {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->push_body('
BuildRequires: tomcat5-jsp-2.0-api
Requires: tomcat5-jsp-2.0-api
');
}
