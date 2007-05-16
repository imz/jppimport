#!/usr/bin/perl -w

require 'remove_java_devel.pl';
$spechook = sub {
    my ($jpp, $alt) = @_;
    &remove_java_devel($jpp, $alt);
#    $jpp->get_section('package','')->unshift_body("BuildRequires: gcc-c++\n");
    $jpp->get_section('package','')->unshift_body("\%define _with_native 1\n");

    $jpp->get_section('prep')->push_body('%patch1 -p1'."\n");
    $jpp->get_section('package','')->push_body('Patch1: jakarta-commons-daemon-1.0.1-libs.patch'."\n");
    # hack!! to implement in clean way
    $jpp->copy_to_sources($jpptoolsdir.'/'.'patches/jakarta-commons-daemon-1.0.1-libs.patch');

}
