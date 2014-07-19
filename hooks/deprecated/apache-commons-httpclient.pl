#!/usr/bin/perl -w

require 'set_fix_repolib_project.pl';
require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # unshift_body after each; something like filter_body {sub}
    my @old_body=@{$jpp->get_section('build')->get_bodyref()};
    my @body;
    while (my $line=shift @old_body) {
	push @body, $line;
	push @body, '-Dmaven.test.skip=true \\'."\n" if $line =~ 'mvn-jpp';
    }
    $jpp->get_section('build')->set_body(\@body);
}

__END__