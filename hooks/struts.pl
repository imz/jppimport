push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'tomcat6-el-1.0-api','tomcat6-el-2.1-api',qr'Requires');

    $jpp->get_section('package','')->push_body('BuildRequires: cssparser
');

    # not to lead into temptation shell.req
    $jpp->get_section('install')->push_body("rm -rf \$RPM_BUILD_ROOT/var/lib/tomcat?/webapps/struts-documentation/download.cgi\n");

}
__END__
