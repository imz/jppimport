#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
};

__END__
    $spec->get_section('package','javadoc')->push_body(q!Provides:       jakarta-%{short_name}-javadoc = 0:%{version}-%{release}!."\n");
