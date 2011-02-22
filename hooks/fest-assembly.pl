#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->subst(qr'','');
#    $jpp->get_section('package','')->subst_if(qr'','',qr'Requires:');
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-shared-archiver maven2-plugin-resources'."\n");
};

__END__
