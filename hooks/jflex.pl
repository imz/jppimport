#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/java/jflex.conf','');
    $jpp->get_section('install')->push_body(q!
%__subst 's,java_cup,java-cup,' $RPM_BUILD_ROOT/%_bindir/jflex
!);
    
}

__END__
