#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # jpp5 bug to report (requires quartz instead of quartz16)
    $jpp->get_section('package','demo')->subst_if('quartz ','quartz16 ',qr'^Requires:');
}
