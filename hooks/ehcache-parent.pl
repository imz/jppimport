#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q!Obsoletes: ehcache1-parent < 2.0!."\n");
};

__END__
