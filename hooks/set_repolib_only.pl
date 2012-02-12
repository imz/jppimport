#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    my $oldname = $jpp->get_section('package','')->get_tag('Name');
    $jpp->rename_main_package($oldname.'-repolib');
    foreach my $section ($jpp->get_sections()) {
	my $type = $section->get_type();
	if ($type=~/^(pre|post|preun|postun|trigger.*)$/) {
	    $section->delete();
	} elsif ($type eq 'files') {
	    if ($section->get_raw_package() ne 'repolib') {
	    	$section->delete();
	    } else {
		$section->get_bodyref()->[0]='%files'."\n";
	    }
	}
    }
};
