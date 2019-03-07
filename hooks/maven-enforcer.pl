#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    $spec->get_section('package','api')->push_body('Provides: maven-shared-enforcer-rule-api = %{version}-%{release}'."\n");
}
