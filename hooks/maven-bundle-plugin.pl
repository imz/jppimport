#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'\%{epoch}:','',qr'^(?:Provides|Obsoletes):');
};

__END__