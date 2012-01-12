push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-corba-1.0-apis geronimo-j2ee-connector-1.5-api'."\n");
};
__END__
