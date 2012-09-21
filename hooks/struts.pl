push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # not to lead into temptation shell.req
    $jpp->get_section('install')->push_body("rm -rf \$RPM_BUILD_ROOT/var/lib/tomcat?/webapps/struts-documentation/download.cgi\n");

}
__END__
    $jpp->get_section('package','')->subst_if(qr'tomcat6-el-1.0-api','tomcat6-el-2.1-api',qr'Requires');
    $jpp->get_section('package','')->unshift_body('BuildRequires: cssparser'."\n");
