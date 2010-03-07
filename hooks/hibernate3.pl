#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: docbook-xml docbook-dtds'."\n");
#    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): j2se-jdbc'."\n");
};

1;
