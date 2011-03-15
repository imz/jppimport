#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: avalon-logkit'."\n");
    $jpp->add_patch('rmock-com.agical.rdoc-pom-alt-javacc5.patch', STRIP => 0);
}
