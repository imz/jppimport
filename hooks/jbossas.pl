#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'antlr-repolib = 0:2.7.6','antlr-repolib >= 0:2.7.6');
    $jpp->get_section('package','')->subst(qr'bcel-repolib = 0:5.1','bcel-repolib >= 0:5.1');
}

