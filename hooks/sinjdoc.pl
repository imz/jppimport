#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'^Obsoletes: gjdoc','#Obsoletes: gjdoc <= 0.7.7-14.fc7');
}
