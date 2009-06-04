#!/usr/bin/perl -w

#set java 6

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): java-1.4.2-devel java-1.5.0-devel java-1.6.0-devel'."\n");
    $jpp->rename_package('bouncycastle13');
    $jpp->get_section('package','jdk1.4')->push_body('Provides: bouncycastle-jdk1.4 = %version'."\n");
    $jpp->get_section('package','jdk1.5')->push_body('Provides: bouncycastle-jdk1.5 = %version'."\n");
    $jpp->get_section('package','jdk1.6')->push_body('Provides: bouncycastle-jdk1.6 = %version'."\n");
}
