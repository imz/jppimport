#require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # BUG: geronimo still not provides that
    $jpp->get_section('package','')->subst_if(qr'qname_1_1_api','geronimo-qname-1.1-api',qr'Requires:');
};
