#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # TODO: the problem is, all gmaven parts are built with groovy 10, 
    # instead of gmaven-runtime-1.5 to be built with groovy 1.5.8.
    # so deep refactoring (perhaps, build should be separated) is required.

    # patch does not help -- need refactoring see above
    $jpp->add_patch('gmaven-1.0-alt-groovy158-support.patch', STRIP=>0);
};

__END__
