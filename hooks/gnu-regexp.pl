#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($spec,) = @_;
    $spec->get_section('package','demo')->subst_body_if(qr'gnu.getopt.+','gnu-getopt',qr'equire');
}
