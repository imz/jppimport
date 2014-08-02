#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body('chmod 755 $RPM_BUILD_ROOT%{_bindir}/*'."\n");
};

