#!/usr/bin/perl -w

push @SPECHOOKS, \&set_bootstrap;

sub set_bootstrap {
    my ($jpp, $alt) = @_;
    my $fixN=$jpp->add_source('fix_share_symlinks_to_libdir.pl');
    $jpp->get_section('install')->push_body('# fix /usr/share symlinks to _libdir
perl %{SOURCE'.$fixN.'} %buildroot'."\n");
}
