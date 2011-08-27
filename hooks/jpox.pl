#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('JPOX-1.1.1-alt-jpp5.patch',STRIP=>1);
    $jpp->get_section('build')->unshift_body_after(qr'^maven','-Dmaven.test.skip=true \\');
}
