#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: asm2'."\n");
    # bug in asm2: 
    # looks like missing group causes ...
    # but it is wise to replace asm-parent to asm-all!
    
}
