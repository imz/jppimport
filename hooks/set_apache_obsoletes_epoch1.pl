#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    $jpp->get_section('package','')->push_body('Obsoletes: jakarta-%{short_name} < 1:%{version}-%{release}'."\n");
    $jpp->get_section('package','')->push_body('Conflicts: jakarta-%{short_name} < 1:%{version}-%{release}'."\n");
}