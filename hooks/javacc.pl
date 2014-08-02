#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # for the sake of openjpa
    $jpp->get_section('install')->push_body(q!ln -s javacc.sh %buildroot%_bindir/%name!."\n");
    $jpp->get_section('files')->push_body(q!%_bindir/%name!."\n");
};

__END__
