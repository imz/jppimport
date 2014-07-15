#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

__END__
    $jpp->get_section('package','javadoc')->push_body(q!Provides:       jakarta-%{short_name}-javadoc = 0:%{version}-%{release}!."\n");
