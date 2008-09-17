#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->push_body('%patch33 -p1'."\n");
    $jpp->get_section('package','')->push_body('Patch33: fop-0.20.5-fix-javadoc.patch'."\n");
    # hack!! to implement in clean way
    $jpp->copy_to_sources($jpptoolsdir.'/'.'patches/fop-0.20.5-fix-javadoc.patch');
}
