push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'BuildRequires: jts','#BuildRequires: jts');
    $jpp->get_section('prep')->push_body('
pushd lib
mv ots-jts_1.0.jar.no ots-jts_1.0.jar
popd
');
    $jpp->get_section('build')->subst(qr'jts ',' ');
    $jpp->get_section('build')->subst(qr'build/classes:build/tests','build/classes:build/tests:lib/ots-jts_1.0.jar');

};
__END__
