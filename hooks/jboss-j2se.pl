#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
}
__END__
    $jpp->add_patch('jboss-4-generic-alt-ant17support.patch', STRIP=>1);
