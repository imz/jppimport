#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q!
Provides: mojo-maven2-plugin-cobertura = 18
Obsoletes: mojo-maven2-plugin-cobertura < 18
!."\n");
};

__END__
