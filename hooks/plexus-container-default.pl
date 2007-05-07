#!/usr/bin/perl -w

require 'set_without_maven.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    &set_without_maven($jpp, $alt);
    $jpp->get_section('package','')->unshift_body('Requires: ant-junit'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-junit'."\n");
}
