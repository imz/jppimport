push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # not to lead into temptation shell.req
    $jpp->get_section('install')->push_body("rm -rf \$RPM_BUILD_ROOT/var/lib/tomcat?/webapps/struts-documentation/download.cgi\n");


    #$jpp->get_section('package')->subst_if('jakarta-commons-validator','jakarta-commons-validator11','BuildRequires');
    foreach my $section ($jpp->get_sections()){
	$section->subst(qr'classpath commons-validator','classpath commons-validator11');
	$section->subst_if(qr'commons-validator','commons-validator11',qr'Req');
	$section->subst(qr'commons-validator','commons-validator11') if $section->get_type()=~/pre|post/;
	
    }

    $jpp->disable_package('webapps-tomcat4');
    $jpp->disable_package('webapps-tomcat3');
}
__END__
