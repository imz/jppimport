#!/usr/bin/perl -w

# strange; it just does not build under java-1.5.0-sun-17 :(
# with eraser error
require 'set_target_15.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
};

