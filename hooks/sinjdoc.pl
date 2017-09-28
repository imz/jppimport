#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->subst_body(qr'^Obsoletes: gjdoc','#Obsoletes: gjdoc <= 0.7.7-14.fc7');
}
