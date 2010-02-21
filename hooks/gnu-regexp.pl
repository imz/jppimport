#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','demo')->subst_if(qr'gnu.getopt','gnu-getopt',qr'equire');
}
