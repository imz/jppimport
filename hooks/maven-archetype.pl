#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body('Provides: maven-archetype2 = %version
Obsoletes: maven-archetype2 < %version
'."\n");
};

__END__
