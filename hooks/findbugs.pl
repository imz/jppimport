#!/usr/bin/perl -w
require 'set_javadoc_namelink_check.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: tex(pdftex.def)'."\n");
};

__END__
