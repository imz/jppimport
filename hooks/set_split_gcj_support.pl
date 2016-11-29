#!/usr/bin/perl -w

push @SPECHOOKS, \&set_split_gcj_support;

sub set_split_gcj_support {
    my ($spec, $parent) = @_;
	$spec->applied_block(
	"set_split_gcj_support hook",
	sub {
    $spec->get_section('package','')->subst(qr'(?<=\?_without_gcj)\s$','');
    $spec->get_section('package','')->subst(qr'(?<=\?_gcj_sup)\s$','');
    $spec->get_section('package','')->subst(qr'(?<=_gcj_support}}\%{!\?_g)\s$','');
	    });

#_gcj_support}}%{!?_g
#%define gcj_support %{?_with_gcj_support:1}%{!?_with_gcj_support:%{?_without_gcj
#_support:0}%{!?_without_gcj_support:%{?_gcj_support:%{_gcj_support}}%{!?_gcj_sup
}

1;
