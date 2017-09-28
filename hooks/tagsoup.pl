#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('Requires: xalan-j2'."\n");
    $spec->get_section('package','')->unshift_body('BuildRequires: xalan-j2'."\n");
    #$spec->get_section('package','')->subst_body_if(qr'','',qr'Requires:');
}
