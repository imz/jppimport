#!/usr/bin/perl -w


push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'java_cup','java-cup',qr'Requires:');
    $jpp->get_section('install')->push_body(q!
%__subst 's,java_cup,java-cup,' $RPM_BUILD_ROOT/%_bindir/jflex
!);
    
}

__END__
5.0
#require 'set_bcond_convert.pl';
    # bug, reported to 5.0 as #309
    $jpp->get_section('install')->push_body(q!
%__subst 's,BASE_JARS="jflex",BASE_JARS="jflex java-cup",' $RPM_BUILD_ROOT/%_bindir/jflex
!);
