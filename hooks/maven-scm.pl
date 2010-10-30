#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','',)->push_body('BuildRequires: modello-maven-plugin saxpath'."\n");
    # added symlink maven-scm.jar in %{_datadir}/maven2/plugins
    $jpp->get_section('install')->unshift_body_after('(cd $RPM_BUILD_ROOT%{_datadir}/maven2/plugins && for jar in *-%{namedversion}*; do ln -sf ${jar} `echo $jar| sed  "s|-%{namedversion}||g"`; done)'."\n",
	qr'add_to_maven_depmap org.apache.maven.plugins maven-scm-plugin');

};
__END__
