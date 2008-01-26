#!/usr/bin/perl -w

require 'set_rename_package.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    &rename_package ($jpp, $alt, 'velocity', 'velocity14');
    $jpp->get_section('package','')->unshift_body('Provides: velocity = 1.4'."\n");
    $jpp->get_section('install')->push_body('rm %buildroot%_javadir/velocity.jar'."\n");
};
