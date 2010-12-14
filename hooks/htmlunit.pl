require 'set_jetty6_servlet_25_api.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # no need to keep 2 commons-collections
    $jpp->get_section('package','')->subst_if(qr'jakarta-commons-lang24','commons-lang',qr'Requires:');
    $jpp->get_section('package','')->subst_if('jakarta-commons-collections32','jakarta-commons-collections',qr'Requires:');
    $jpp->get_section('build')->subst(qr'commons-lang24','commons-lang');
    $jpp->get_section('build')->subst(qr'commons-collections32','commons-collections');

};
__END__
# fix jpp depmap
s,commons-lang24,commons-lang,
s,commons-collections32,commons-collections,
