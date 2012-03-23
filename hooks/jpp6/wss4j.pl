push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # alt prehistory ? :(
    $jpp->get_section('package','')->subst(qr'BuildRequires: java-1.5.0-sun-jce-policy','#BuildRequires: java-1.5.0-sun-jce-policy');
    $jpp->get_section('prep')->subst(qr'build-classpath bouncycastle/bcprov','build-classpath bcprov');
}



__END__
