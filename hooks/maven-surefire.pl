#!/usr/bin/perl -w

require 'set_without_maven.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package')->subst(qr'^Requires: maven2-bootstrap','#Requires: maven2');
    $jpp->get_section('package')->unshift_body('BuildRequires: plexus-archiver'."\n");
    $jpp->add_patch('maven-surefire-2.3.1-alt-debug-1.patch');

}
