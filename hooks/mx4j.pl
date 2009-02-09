#!/usr/bin/perl -w

#require 'set_bootstrap.pl';
require 'set_target_14.pl';
# too long :(
require 'set_without_tests.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'javamail\s+>=\s+0:1.2-5jpp','javamail');
    # no network; hm... maybe altspecific...
    $jpp->add_patch('mx4j-3.0.1-alt-local-xsl-stylesheets.patch');
}
