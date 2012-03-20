#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    $jpp->add_patch('serp-1.13.1-alt-pom-use-maven-jxr.patch', STRIP=>0);

};

__END__
