#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->unshift_body('export MAVEN_OPTS="-Xmx256m"'."\n");


    $jpp->get_section('package','')->subst_if('maven-plugin-modello','modello-maven-plugin',qr'Requires:');
    $jpp->get_section('package','',)->push_body('BuildRequires: maven-shared-downloader'."\n");
    #$jpp->get_section('package','',)->push_body('BuildRequires: saxpath'."\n");

    # added symlink maven-scm.jar in %{_datadir}/maven2/plugins
    $jpp->get_section('install')->unshift_body2_after('(cd $RPM_BUILD_ROOT%{_datadir}/maven2/plugins && for jar in *-%{namedversion}*; do ln -sf ${jar} `echo $jar| sed  "s|-%{namedversion}||g"`; done)'."\n",
	qr'add_to_maven_depmap org.apache.maven.plugins maven-scm-plugin');

};
__END__
