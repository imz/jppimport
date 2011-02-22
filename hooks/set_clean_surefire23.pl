#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'\s+=\s+2.3','',qr'^BuildRequires:\s+maven-surefire');
}
