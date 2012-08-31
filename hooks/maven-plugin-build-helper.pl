#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q!
Provides: mojo-maven2-plugin-build-helper = %version
Obsoletes: mojo-maven2-plugin-build-helper = 17
!."\n");
};

__END__
