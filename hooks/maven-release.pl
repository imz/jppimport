#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','plugin')->push_body(q!Provides: maven2-plugin-release = %version!."\n");
};

__END__
