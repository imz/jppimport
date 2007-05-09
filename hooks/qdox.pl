#!/usr/bin/perl -w

require 'set_without_maven.pl';
require 'set_split_gcj_support.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    &set_without_maven($jpp, $alt);
    &set_split_gcj_support($jpp, $alt);
}
