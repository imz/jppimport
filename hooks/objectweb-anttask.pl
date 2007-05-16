#!/usr/bin/perl -w

require 'remove_java_devel.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    &remove_java_devel($jpp, $alt);

    $jpp->get_section('package','')->unshift_body('%define _bootstrap 1'."\n");

    $jpp->get_section('prep')->push_body('%patch33 -p1'."\n");
    $jpp->get_section('package','')->push_body('Patch33: objectweb-anttask-1.3.2-ant-1.7.0-alt.patch'."\n");
    # hack!! to implement in clean way
    $jpp->copy_to_sources($jpptoolsdir.'/'.'patches/objectweb-anttask-1.3.2-ant-1.7.0-alt.patch');
}
