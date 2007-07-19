#!/usr/bin/perl -w

require 'set_without_maven.pl';
require 'set_target_14.pl';

$spechook = \&fix_svn;

sub fix_svn {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: subversion'."\n");
}

1;
