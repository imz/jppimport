#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    $spec->get_section('package')->push_body('%define java_bin %_jvmdir/java/bin'."\n");
}
