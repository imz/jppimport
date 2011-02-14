
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # site
    #$jpp->get_section('package','')->unshift_body("BuildRequires: velocity14\n");
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-plugin-tools mojo-maven2-plugin-rat\n");
};

__END__
