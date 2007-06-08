#!/usr/bin/perl -w

push @SPECHOOKS, \&set_fix_jakarta_commons_cli;

sub set_fix_jakarta_commons_cli {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*jakarta-commons-cli','BuildRequires: jakarta-commons-cli-1');
}
