#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: h2database'."\n");
    $spec->get_section('prep')->subst_body_if(qr'_javadir}/h2.jar','_javadir}/h2database.jar',qr'ln -s');
};

