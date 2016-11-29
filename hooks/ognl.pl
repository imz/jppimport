#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->source_apply_patch(SOURCEFILE=>'ognl-2.7.3.pom', PATCHFILE=>'ognl-2.7.3.pom-alt.patch');
    # pom dependency
    $spec->get_section('package','')->push_body(q!Requires: javassist!."\n");
};

__END__
