#!/usr/bin/perl -w

$spechook = sub {
    my ($spec, $parent) = @_;
# bugfix; to be commited in bugzilla
    $spec->get_section('package','')->subst(qr'\%7Eappel','%%7Eappel');

#    $spec->get_section('prep')->push_body('%patch -p1'."\n");
#    $spec->get_section('package','')->push_body('Patch: java_cup-alt-javadoc.patch'."\n");
    # hack!! to implement in clean way
#    $spec->copy_to_sources($spectoolsdir.'/'.'patches/java_cup-alt-javadoc.patch');
}
