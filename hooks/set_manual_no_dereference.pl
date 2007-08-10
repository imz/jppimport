#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('files','manual')->subst(qr'^\s*%doc\s+target/dist','%doc --no-dereference target/dist');
    $jpp->get_section('files','manual')->subst(qr'^\s*%doc\s+build/docs','%doc --no-dereference build/docs');
    $jpp->get_section('files','manual')->subst(qr'^\s*%doc\s+dist/docs','%doc --no-dereference dist/docs');
    $jpp->get_section('files','manual')->subst(qr'^\s*%doc\s+docs/','%doc --no-dereference docs/');
}
;
