#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->subst(qr'%setup -q -c -n %{name}',
	'%setup -T -c -n %{name}'."\n".'unzip %{SOURCE0}'."\n");
}
