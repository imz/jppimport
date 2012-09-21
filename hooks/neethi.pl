#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # autorenamed to ws-commons-neethi
    $jpp->get_section('package','')->push_body(q!Provides: neethi = %version!."\n");
};

__END__
