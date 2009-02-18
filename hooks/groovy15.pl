push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # TODO: lucene1
    $jpp->get_section('package','')->subst_if('lucene','lucene1', qr'Requires:');

};
