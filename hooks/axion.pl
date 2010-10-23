#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('package','')->unshift_body('BuildRequires: log4j'."\n");
    if ($jpp->get_section('install')->match('add_to_maven_depmap')) {
	die "hook is deprecated!!! cleanup /patches!!!";
    } else {
	# TODO
	#$jpp->get_section('package')->subst(qr'jakarta-commons-primitives','apache-commons-primitives');

	my $sourceid=$jpp->add_source('axion-1.0-M3-dev.pom');
	$jpp->get_section('install')->push_body(q!
# poms
install -d -m 755 $RPM_BUILD_ROOT%{_datadir}/maven2/poms
install -m 644 %{SOURCE!.$sourceid.q!} \
    $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP-%{name}.pom

%add_to_maven_depmap %{name} %{name} %{version} JPP %{name}
!);
	$jpp->get_section('files','')->push_body(q!
%{_mavendepmapfragdir}/*
%{_datadir}/maven2/poms/*
!);
    }
}
