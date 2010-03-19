#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # old jaxen?
    $jpp->get_section('package','')->unshift_body('BuildRequires: rome'."\n");
    $jpp->get_section('build')->unshift_body_before(q!
mvn-jpp -e \
         -s ${M2SETTINGS} \
         -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
         -Dmaven2.jpp.depmap.file=%{SOURCE2} \
       install:install-file -DgroupId=rome -DartifactId=rome \
                 -Dversion=0.8 -Dpackaging=jar -Dfile=$(build-classpath rome-0.9)
!,qr'mvn-jpp');

    #ln -s %{name}-api-%{version} $RPM_BUILD_ROOT%{_javadocdir}/%{name} # ghost symlink
    $jpp->get_section('install')->subst(qr'ln -s \%{name}-api-\%{version}','ln -s %{name}-%{version}');
    #$jpp->get_section('files','javadoc')->subst(qr'ln -s \%{name}-api-\%{version}','#ln -s %{name}-%{version}');
};
__END__