#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # jpp5 bug to report (requires quartz instead of quartz16)
    $jpp->get_section('package','demo')->subst_if('quartz ','quartz16 ',qr'^Requires:');

    $jpp->get_section('package','')->push_body('
# nothing but examples
%add_findreq_skiplist %_datadir/%name-%version/bin/*
%add_findprov_skiplist %_datadir/%name-%version/bin/*
');

}
