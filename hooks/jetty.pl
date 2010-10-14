#!/usr/bin/perl -w

#die;

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # BuildRequires:\s+fedora-usermgmt-devel
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s+fedora-usermgmt-devel','');
    $jpp->applied_block(
	"tmp hack TODO fix in import",
	sub {
	    foreach my $section ($jpp->get_sections()) {
		if ($section->get_type() =~ '^(pre|post)') {
		    $section->subst(qr'\%__fe_','');
		}
	    }
	}
	);

}
__END__
предупреждение: Macro %__fe_groupadd not found
предупреждение: Macro %__fe_useradd not found
предупреждение: Macro %__fe_userdel not found
предупреждение: Macro %__fe_groupdel not found
