#!/usr/bin/perl -w

push @SPECHOOKS, \&set_target_13;
#$spechook = \&set_target_14;

sub set_target_13 {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->subst(qr'^(\s*ant\s)','ant -Dant.build.javac.source=1.3 -Dant.build.javac.target=1.3 ');
    $jpp->get_section('build')->subst(qr'^(\s*ant\s)','ant -Dant.build.javac.source=1.3 -Dant.build.javac.target=1.3 ');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*jpackage-1.4-compat','##BuildRequires: jpackage-generic-compat');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*jpackage-1.4-compat','BuildRequires: jpackage-1.5-compat');
}
