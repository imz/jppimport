
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # hack for rebuild w/maven208
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-surefire-provider-junit maven-surefire-provider-junit4
\n");
};

__END__
