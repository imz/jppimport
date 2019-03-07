#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('Obsoletes: jakarta-regexp = 1.4-alt4'."\n");
    $spec->get_section('package','')->unshift_body('Obsoletes: jakarta-regexp = 1.4-alt3'."\n");
    $spec->get_section('package','')->unshift_body('Obsoletes: jakarta-regexp = 1.4-alt2'."\n");
    $spec->get_section('package','')->unshift_body('Obsoletes: jakarta-regexp = 1.4-alt1'."\n");
    $spec->get_section('package','')->push_body('Provides: jakarta-regexp = %{version}-%{release}'."\n");
    $spec->get_section('pretrans','javadoc')->delete;
}
