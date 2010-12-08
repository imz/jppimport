#!/usr/bin/perl -w

require 'set_manual_no_dereference.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#E: Версия >='0:1.2-5jpp' для 'javamail'
    $jpp->get_section('package','javamail')->subst_if(qr'>= 0:1.2-5jpp','',qr'Requires');
    $jpp->get_section('package','javamail')->subst_if(qr'>=\s+0:1.0.1-5jpp','',qr'Requires');
    $jpp->add_patch('apache-ant-1.7.1-alt-commons-net2.0.patch',STRIP=>1);
}



__END__
