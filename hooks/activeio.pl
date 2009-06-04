#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: avalon-framework avalon-logkit'."\n");
    $jpp->get_section('prep')->push_body('rm src/test/org/activeio/ChannelFactoryTest.java'."\n");
}
