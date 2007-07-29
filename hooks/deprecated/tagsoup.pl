#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # hack around alt ant
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-trax'."\n");
#    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-optional'."\n");
}
