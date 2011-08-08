#!/usr/bin/perl -w

require 'set_fix_repolib_project.pl';
require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: velocity14'."\n");

    # unshift_body after each; something like filter_body {sub}
    my @old_body=@{$jpp->get_section('build')->get_body()};
    my @body;
    while (my $line=shift @old_body) {
	push @body, $line;
	push @body, '-Dmaven.test.skip=true \\'."\n" if $line =~ 'mvn-jpp';
    }
    $jpp->get_section('build')->set_body(\@body);
}

__END__
