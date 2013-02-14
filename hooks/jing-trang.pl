#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%filter_from_requires /.etc.java.jing-trang.conf/d'."\n");
};

__END__
