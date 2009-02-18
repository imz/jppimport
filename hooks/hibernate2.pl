require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if('ehcache-bootstrap','ehcache',qr'BuildRequires');
};
