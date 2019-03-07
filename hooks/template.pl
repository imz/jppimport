#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->add_patch('',STRIP=>1);
    $spec->get_section('package','')->subst_body(qr'','');
    $spec->get_section('package','')->subst_body_if(qr'','',qr'Requires:');
    $spec->get_section('prep')->push_body(q!!."\n");
    $spec->get_section('install')->push_body(q!!."\n");
    $spec->get_section('package','')->unshift_body('BuildRequires: '."\n");
    $spec->get_section('package','')->push_body('Provides: '."\n");
};

__END__
