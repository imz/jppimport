#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->subst(qr'itest-beans.jar','itests-beans.jar');
}
