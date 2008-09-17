#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # this test hangs for hours
    $jpp->get_section('prep')->push_body('rm src/test/java/org/codehaus/plexus/scheduler/SchedulerTest.java'."\n");
}
