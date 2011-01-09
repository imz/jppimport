#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'','');
    $jpp->get_section('package','')->subst_if(qr'','',qr'Requires:');
    $jpp->get_section('package','')->unshift_body('BuildRequires: '."\n");
};

__END__
