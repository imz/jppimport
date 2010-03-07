#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
# bugfix; to be commited in bugzilla
    #$jpp->get_section('package','')->subst(qr'^BuildArch:','##BuildArch:');
    #$jpp->get_section('package','')->subst(qr'^BuildRequires: jpackage-1.4-compat','##BuildRequires: jpackage-1.4-compat');
    #$jpp->get_section('package','')->subst(qr'^BuildRequires: /proc','##BuildRequires: /proc');
}
