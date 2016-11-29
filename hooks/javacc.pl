#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;

    # for the sake of openjpa
    $spec->get_section('install')->push_body(q!ln -s javacc.sh %buildroot%_bindir/%name!."\n");
    $spec->get_section('files')->push_body(q!%_bindir/%name!."\n");
};

__END__
