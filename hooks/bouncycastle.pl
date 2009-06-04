#!/usr/bin/perl -w

#set java 6

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): java-1.4.2-devel java-1.5.0-devel java-1.6.0-devel'."\n");
    $jpp->get_section('package','')->push_body('Provides: bouncycastle-mail = %version'."\n");
}
