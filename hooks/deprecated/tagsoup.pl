#!/usr/bin/perl -w

$spechook = sub {
    my ($spec,) = @_;
    # hack around alt ant
    $spec->get_section('package','')->unshift_body('BuildRequires: ant-trax'."\n");
#    $spec->get_section('package','')->unshift_body('BuildRequires: ant-optional'."\n");
}
