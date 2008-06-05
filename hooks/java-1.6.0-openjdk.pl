#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body(q'BuildRequires: gcc-c++ eclipse-ecj
');

    $jpp->get_section('package','')->subst(qr'java-1.5.0-gcj-devel','java-1.6.0-sun-devel');
    $jpp->get_section('package','')->subst(qr'java-1.6.0-openjdk-devel','java-1.6.0-sun-devel');
    $jpp->get_section('package','')->subst(qr'java-1.6.0-openjdk-devel','java-1.6.0-sun-devel');
    $jpp->get_section('package','')->subst(qr'gecko-devel','firefox-devel');
    $jpp->get_section('package','')->subst(qr'^Epoch:\s+1','Epoch: 0');
    $jpp->get_section('build')->subst(qr'./configure','./configure --with-openjdk-home=/usr/lib/jvm/java');
}
