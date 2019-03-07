#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;

    $spec->get_section('package','')->push_body('Obsoletes: jakarta-%{short_name} < 1:%{version}-%{release}'."\n");
    $spec->get_section('package','')->push_body('Conflicts: jakarta-%{short_name} < 1:%{version}-%{release}'."\n");
}
