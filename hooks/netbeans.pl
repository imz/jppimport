push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if('lucene', 'lucene2', qr'Requires:');
    $jpp->get_section('build')->subst(qr'lucene.jar','lucene2.jar');
    $jpp->get_section('install')->subst(qr'lucene.jar','lucene2.jar');
  
};

