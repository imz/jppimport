#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'Obsoletes:','#Obsoletes:',qr'msv');
#    $jpp->get_section('prep')->subst(qr'%setup -q -n %{name}-%{version}',
#	'%setup -T -c -n %{name}-%{version}'."\n".'cd ..; unzip %{SOURCE0}'."\n".'cd %{name}-%{version}'."\n");
}
