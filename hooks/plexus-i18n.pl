push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: plexus-maven-plugin\n");
};

1;
