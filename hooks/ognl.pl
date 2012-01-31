#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->source_apply_patch(SOURCEFILE=>'ognl-2.7.3.pom', PATCHFILE=>'ognl-2.7.3.pom-alt.patch');
    # pom dependency
    $jpp->get_section('package','')->push_body(q!Requires: javassist!."\n");
};

__END__
