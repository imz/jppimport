push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    # not to lead into temptation shell.req
    $spec->get_section('install')->push_body("rm -rf \$RPM_BUILD_ROOT/var/lib/tomcat?/webapps/struts-documentation/download.cgi\n");

}
__END__
