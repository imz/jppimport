#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # hack around splitting on 2 packages
    if ($alt->get_tag('Name') eq 'jsvc') {
	$jpp->get_section('package','')->unshift_body("\%define _with_native 1\n");
	$jpp->raw_rename_section('jsvc','-n jakarta-commons-daemon-jsvc');
	$jpp->get_section('package','')->subst(qr'%{name}-crosslink.patch','jakarta-commons-daemon-crosslink.patch');
    }
    
    $jpp->get_section('prep')->push_body('%patch1 -p1'."\n");
    $jpp->get_section('package','')->push_body('Patch1: jakarta-commons-daemon-1.0.1-libs.patch'."\n");
    # hack!! to implement in clean way
    $jpp->copy_to_sources($jpptoolsdir.'/'.'patches/jakarta-commons-daemon-1.0.1-libs.patch');

}
