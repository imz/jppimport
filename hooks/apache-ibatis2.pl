#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->subst(qr'abator-core','ibator-core');
};

__END__
