#!/usr/bin/perl -w

#die;

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

#предупреждение: Macro %__fe_groupadd not found
#предупреждение: Macro %__fe_useradd not found
#предупреждение: Macro %__fe_userdel not found
#предупреждение: Macro %__fe_groupdel not found
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

 
   $jpp->apply_to_sources(SOURCEFILE=>'jetty.init', PATCHFILE=>'jetty.init.diff');
    #if ($jpp->get_section('package','')->match_body(qr'Source7:\s+jetty.init\s*$')) {
    #	$jpp->get_section('prep')->push_body("sed -i 's,daemon --user,start_daemon --user,' %SOURCE7"."\n");
    #}


}
__END__
