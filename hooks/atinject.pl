#!/usr/bin/perl -w

require 'set_osgi_fc.pl';

__END__
push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('prep')->push_body(q!# fix insource
sed -i 's,javac -g,javac -source 1.6 -target 1.6 -g,' build.sh
!."\n");
};

