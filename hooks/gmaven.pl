#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-archetypeng'."\n");
};

__END__
# 5.0
    # TODO: the problem is, all gmaven parts are built with groovy 10, 
    # instead of gmaven-runtime-1.5 to be built with groovy 1.5.8.
    # so deep refactoring (perhaps, build should be separated) is required.

    # patch does not help -- need refactoring see above
    $jpp->add_patch('gmaven-1.0-alt-groovy158-support.patch', STRIP=>0);
