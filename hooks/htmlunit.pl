require 'set_jetty6_servlet_25_api.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'jakarta-commons-lang24','commons-lang',qr'Requires:');
    $jpp->get_section('build')->subst(qr'commons-lang24','commons-lang');
};
__END__
