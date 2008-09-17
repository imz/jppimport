#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # E: Версия >='0:1.0.1-0.a.1' для 'jta' не найдена
    $jpp->get_section('package','')->subst_if(qr'0:1.0.1-0.a.1','0:1.0.1',qr'Requires:');
};

