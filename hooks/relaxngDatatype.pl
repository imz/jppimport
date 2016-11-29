#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
#    $spec->get_section('package','')->subst_if(qr'Obsoletes:','#Obsoletes:',qr'msv');
}
