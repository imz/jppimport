push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # TODO: fix cli!
    $jpp->get_section('package','')->unshift_body("BuildRequires: jakarta-commons-cli\n");
};
