#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->add_patch('',STRIP=>1);
    $jpp->get_section('package','')->subst_body(qr'','');
    $jpp->get_section('package','')->subst_body_if(qr'','',qr'Requires:');
    $jpp->get_section('package','')->unshift_body('BuildRequires: '."\n");
    $jpp->get_section('prep')->push_body(q!!."\n");
};

__END__
