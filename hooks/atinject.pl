#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->push_body(q!# fix insource
sed -i 's,javac -g,javac -source 1.5 -target 1.5 -g,' build.sh
!."\n");
};

__END__