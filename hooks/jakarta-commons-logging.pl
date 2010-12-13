#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('commons-logging-eclipse-manifest.patch',STRIP=>0);
}
__END__
