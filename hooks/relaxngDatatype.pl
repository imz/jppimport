#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->subst(qr'%setup -q -n %{name}-%{version}',
	'%setup -T -c -n %{name}-%{version}'."\n".'cd ..; unzip %{SOURCE0}'."\n".'cd %{name}-%{version}'."\n");
}
