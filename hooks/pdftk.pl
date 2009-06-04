#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: gcc-c++'."\n");

    # itext -> itext2 
    $jpp->get_section('package','')->subst_if(qr'itext\s*>=\s*\S+','itext2',qr'Requires:');
    $jpp->get_section('build')->subst(qr'/itext-','/itext2-');
    $jpp->get_section('prep')->push_body('
subst s,itext/itext,itext2/itext2, pdftk/Makefile.Base
');

};
