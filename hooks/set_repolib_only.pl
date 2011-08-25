#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    my $oldname = $jpp->get_section('package','')->get_tag('Name');
    $jpp->rename_main_package($oldname.'-repolib');
    foreach my $section ($jpp->get_sections()) {
	my $type = $section->get_type();
	if ($type=~/^(pre|post|preun|postun|trigger.*)$/) {
	    $jpp->del_section(
		$section->get_type(),
		$section->get_package(),
		$section->get_trigger_condition()
		);
	} elsif ($type eq 'files') {
	    if ($section->get_package() ne 'repolib') {
	    $jpp->del_section(
		$section->get_type(),
		$section->get_package(),
		$section->get_trigger_condition()
		);
	    } else {
		$section->get_bodyref()->[0]='%files'."\n";
	    }
	}
    }
};
