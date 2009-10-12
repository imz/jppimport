#!/usr/bin/perl -w

require 'windows-thumbnail-database-in-package.pl';
require 'set_dos2unix_scripts.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
}
