#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('Provides: maven-shared-enforcer-rule-api = %{version}-%{release}'."\n");
    $jpp->get_section('package','')->subst_if(qr'checkstyle = 4.3','checkstyle4',qr'Requires');
}
