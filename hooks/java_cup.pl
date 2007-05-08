#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
# bugfix; to be commited in bugzilla
    $jpp->get_section('package','')->subst(qr'\%7Eappel','%%7Eappel');
    $jpp->get_section('prep')->push_body('%patch -p1'."\n");
    $jpp->get_section('package','')->push_body('Patch: java_cup-alt-javadoc.patch'."\n");
    # hack!! to implement in clean way
    $jpp->copy_to_sources($jpptoolsdir.'patches/java_cup-alt-javadoc.patch');
}
