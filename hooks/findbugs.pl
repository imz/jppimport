#!/usr/bin/perl -w
require 'set_javadoc_namelink_check.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->source_apply_patch(SOURCEFILE=>'findbugs-3.0.1.pom', PATCHFILE=>'findbugs-3.0.1.pom.patch');
    $spec->get_section('package','')->unshift_body('BuildRequires: tex(pdftex.def)'."\n");
};

__END__
