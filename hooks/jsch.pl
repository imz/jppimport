require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # consider including to jpackage-compat
    $jpp->get_section('package','')->unshift_body("BuildRequires: zip\n");
};
