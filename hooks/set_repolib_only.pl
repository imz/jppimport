#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    my $oldname = $spec->get_section('package','')->get_tag('Name');
    $spec->rename_main_package($oldname.'-repolib');
    foreach my $section ($spec->get_sections()) {
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
