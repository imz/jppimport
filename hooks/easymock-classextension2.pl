#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->subst(qr'','');
#    $jpp->get_section('package','')->subst_if(qr'','',qr'Requires:');
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-antrun felix-maven2 maven2-plugin-source'."\n");
};

__END__
