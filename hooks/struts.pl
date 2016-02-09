push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # not to lead into temptation shell.req
    $jpp->get_section('install')->push_body("rm -rf \$RPM_BUILD_ROOT/var/lib/tomcat?/webapps/struts-documentation/download.cgi\n");

}
__END__
