#!/usr/bin/perl -w

push @SPECHOOKS, \&set_bootstrap;

sub set_bootstrap {
    my ($spec,) = @_;
    my $fixN=$spec->add_source('fix_share_symlinks_to_libdir.pl');
    $spec->get_section('install')->push_body('# fix /usr/share symlinks to _libdir
perl %{SOURCE'.$fixN.'} %buildroot'."\n");
}
