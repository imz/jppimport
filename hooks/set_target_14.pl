#!/usr/bin/perl -w

push @SPECHOOKS, \&set_target_14;
#$spechook = \&set_target_14;

sub set_target_14 {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'^(\s*ant\s)','ant -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 ');
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*jpackage-1.4-compat','##BuildRequires: jpackage-generic-compat');
}
