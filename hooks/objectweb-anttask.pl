#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->push_body('%patch33 -p1'."\n");
    $jpp->get_section('package','')->push_body('Patch33: objectweb-anttask-1.3.2-ant-1.7.0-alt.patch'."\n");
    # hack!! to implement in clean way
    $jpp->copy_to_sources($jpptoolsdir.'/'.'patches/objectweb-anttask-1.3.2-ant-1.7.0-alt.patch');
}
