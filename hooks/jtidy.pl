require 'set_bin_755.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # alt prehistory ? :(
    $jpp->get_section('package','')->set_tag('Epoch',2);
}
