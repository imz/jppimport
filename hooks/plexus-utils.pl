#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if('mojo-maven2-plugin-shade','maven2-plugin-shade',qr'Requires:');
}
__END__
