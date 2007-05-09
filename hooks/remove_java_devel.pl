#!/usr/bin/perl -w

$spechook = \&remove_java_devel;

sub remove_java_devel {
    my ($jpp, $alt) = @_;
    # hack around broken deps
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*java-devel','##BuildRequires: java-devel');
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant\s*java-devel','BuildRequires: ant ');
}
