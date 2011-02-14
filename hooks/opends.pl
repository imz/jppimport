#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # del after up
    $jpp->get_section('package','')->unshift_body('BuildRequires: glassfish-jaxb > 2.1.4'."\n");
};

__END__
