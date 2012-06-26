#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('Provides: maven-archetype2 = %version
Obsoletes: maven-archetype2 < %version
'."\n");
};

__END__
