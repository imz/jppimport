#!/usr/bin/perl -w

$spechook = \&set_split_gcj_support;

sub set_split_gcj_support {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'(?<=\?_without_gcj)\s$','');
    $jpp->get_section('package','')->subst(qr'(?<=\?_gcj_sup)\s$','');
#%define gcj_support %{?_with_gcj_support:1}%{!?_with_gcj_support:%{?_without_gcj
#_support:0}%{!?_without_gcj_support:%{?_gcj_support:%{_gcj_support}}%{!?_gcj_sup
}

1;
