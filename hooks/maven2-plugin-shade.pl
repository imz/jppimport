#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'= 2.3','',qr'maven-surefire-plugin');
    $jpp->get_section('package','')->subst_if(qr'= 2.3','',qr'maven-surefire-provider-junit');
  #E: ������ <'0:1.0-0.3.a11' ��� 'plexus-cdc' �� �������
    $jpp->get_section('package','')->subst_if(qr'< 0:1.0-0.3.a11','',qr'plexus-cdc');

};

