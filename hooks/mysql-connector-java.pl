#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # E: ������ >='0:1.0.1-0.a.1' ��� 'jta' �� �������
    $jpp->get_section('package','')->subst_if(qr'0:1.0.1-0.a.1','0:1.0.1',qr'Requires:');
};

