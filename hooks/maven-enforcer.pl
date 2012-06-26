#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','api')->push_body('Provides: maven-shared-enforcer-rule-api = %{version}-%{release}'."\n");
}
