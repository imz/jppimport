#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # maven3
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-remote-resources-plugin\n");


    $jpp->add_patch('apacheds-1.5.4-alt-pom-use-maven2-plugin-shade.patch',STRIP=>1);
    $jpp->add_patch('apacheds-1.5.4-alt-pom-slf4j16.patch',STRIP=>0);
    $jpp->get_section('package','')->subst_if('mojo-maven2-plugin-shade','maven-shade-plugin',qr'Requires:');

    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-surefire-provider-junit4\n");
    # test fails :(
    $jpp->get_section('package','')->unshift_body("BuildRequires: jakarta-commons-net14\n");
    # for build-classpath nlog4j
    $jpp->get_section('package','')->unshift_body("BuildRequires: nlog4j\n");
    $jpp->get_section('package','core')->subst_if('jakarta-commons-collections32','jakarta-commons-collections',qr'Requires:');

    $jpp->applied_block(
	"var lib",
	sub {
	    foreach my $section ($jpp->get_sections()) {
		my $t=$section->get_type();
		if ($t eq 'install' or $t eq 'files') {
		    $section->subst(qr'%{_var}/%{name}','%{_var}/lib/%{name}');
		}
	    }
	}
	);
};

__END__
#1.0.2
