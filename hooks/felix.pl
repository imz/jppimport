#!/usr/bin/perl -w

#require 'set_jetty6_servlet_25_api.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->disable_package('osgi-compendium');
    $jpp->disable_package('osgi-core');
    $jpp->disable_package('osgi-obr');
    $jpp->disable_package('osgi-foundation');
    # separated and disabled manually
    #$jpp->disable_package('framework');
};


__END__
