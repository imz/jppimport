#!/usr/bin/perl -w

#require 'set_jetty6_servlet_25_api.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->disable_package('osgi-compendium');
    $jpp->disable_package('osgi-core');

    $jpp->get_section('package','')->push_body('Requires: felix-framework'."\n");

    $jpp->get_section('package','maven2')->push_body('Requires: felix-framework'."\n");
    # for bundle plugin
    $jpp->get_section('package','maven2')->push_body('Requires: felix-osgi-obr'."\n");
    # for external framework
    $jpp->get_section('package','maven2')->push_body('Requires: felix-parent'."\n");

    $jpp->get_section('package','')->unshift_body('BuildRequires: felix-framework'."\n");

    if (1) { # exclude felix-framework
	$jpp->get_section('install')->subst(qr'add_to_maven_depmap org.apache.felix org.apache.felix',
	'add_to_maven_depmap_at %name-framework org.apache.felix org.apache.felix.framework');
	#/usr/share/java/felix/org.apache.felix.framework.*\.jar
	$jpp->get_section('files')->exclude('org\.apache\.felix\.framework');
	#JPP.felix-org.apache.felix.framework.pom ? let it be - no conflicts :)
    }

    $jpp->get_section('package','osgi-obr')->exclude('^Requires:\s*\%{name}');
    $jpp->get_section('package','osgi-obr')->push_body('Requires: felix-osgi-core'."\n");
    $jpp->get_section('install')->subst(qr'add_to_maven_depmap org.apache.felix org.osgi.service.obr',
	'add_to_maven_depmap_at %name-osgi-obr org.apache.felix org.osgi.service.obr');

    $jpp->get_section('files','osgi-obr')->push_body('%{_mavendepmapfragdir}/%name-osgi-obr'."\n");
    $jpp->get_section('files')->push_body('%exclude %{_mavendepmapfragdir}/%name-*'."\n");

    #$jpp->disable_package('osgi-obr');
    $jpp->disable_package('osgi-foundation');
    # separated and disabled manually
    #$jpp->disable_package('framework');
};


__END__
