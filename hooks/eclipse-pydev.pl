#!/usr/bin/perl -w

require 'set_fix_eclipse_dep.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # altbug#13596
    $jpp->get_section('package','')->push_body('%add_findreq_skiplist /usr/share/eclipse/plugins/org.python.pydev.jython_*/*/*');
};
