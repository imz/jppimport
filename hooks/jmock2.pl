#!/usr/bin/perl -w

# strange; it just does not build under java-1.5.0-sun-17 :(
# with eraser error
# so use java6 

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
};

