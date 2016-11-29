#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('install')->push_body('chmod 755 $RPM_BUILD_ROOT%{_bindir}/*'."\n");
};

