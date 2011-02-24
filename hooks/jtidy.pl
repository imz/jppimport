require 'set_bin_755.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('jtidy-1.0-alt-cleanup-pom-deps.patch', STRIP=>0);
}
