#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
# bugfix; to be commited in bugzilla
    $jpp->get_section('files','manual')->subst(qr'\%doc build/docs/\*','%doc --no-dereference build/docs/*');

    my $count_changelogs=0;
    for (my $i=0; $i<@{$jpp->get_sections()}; $i++) {
	if ($jpp->get_sections()->[$i]->get_type() eq 'changelog') {
	    if ($count_changelogs>0) {
		@{$jpp->get_sections()}[$i..$#{$jpp->get_sections()}-1]=@{$jpp->get_sections()}[$i+1..$#{$jpp->get_sections()}];
		$#{$jpp->get_sections()}--;
	    }
	    $count_changelogs++;
	}
    }

}
