#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->push_body('%define java_bin %_jvmdir/java/bin'."\n");
}
