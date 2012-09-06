#!/usr/bin/perl -w

require 'set_osgi.pl';
require 'set_apache_obsoletes_epoch1.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('files','')->push_body('%exclude %_javadir/repository.jboss.com'."\n");
}

__END__
