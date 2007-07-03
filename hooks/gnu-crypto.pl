#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'%configure','%configure --build=%_arch --host=%_arch');
    $jpp->get_section('install')->subst(qr'%check','#%%check');
}
