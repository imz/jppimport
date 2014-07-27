#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('prep')->push_body(q!
%pom_remove_dep xerces:dom3-xml-apis
!."\n");
};

__END__
