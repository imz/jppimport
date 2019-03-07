#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($spec,) = @_;
    # tmp hack till ant18 migration
    $spec->get_section('package','')->unshift_body('BuildRequires: ant-log4j'."\n");
}
