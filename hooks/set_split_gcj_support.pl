#!/usr/bin/perl -w

push @SPECHOOKS, \&set_split_gcj_support;

sub set_split_gcj_support {
    my ($jpp, $alt) = @_;
	$jpp->applied_block(
	"set_target_$target hook",
	sub {
    $jpp->get_section('package','')->subst(qr'(?<=\?_without_gcj)\s$','');
    $jpp->get_section('package','')->subst(qr'(?<=\?_gcj_sup)\s$','');
    $jpp->get_section('package','')->subst(qr'(?<=_gcj_support}}\%{!\?_g)\s$','');
	    });

#_gcj_support}}%{!?_g
#%define gcj_support %{?_with_gcj_support:1}%{!?_with_gcj_support:%{?_without_gcj
#_support:0}%{!?_without_gcj_support:%{?_gcj_support:%{_gcj_support}}%{!?_gcj_sup
}

1;
