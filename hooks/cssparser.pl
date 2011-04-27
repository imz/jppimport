
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # hack for rebuild w/maven208
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-surefire-provider-junit maven-surefire-provider-junit4
\n");
    # from fedora; for javacc 5
    $jpp->add_patch('cssparser-javacc.patch', STRIP=>0);
};

__END__
