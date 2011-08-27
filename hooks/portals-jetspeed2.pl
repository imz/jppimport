#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # old jaxen?
    $jpp->get_section('package','')->subst_if('lucene22','lucene',qr'Requires');
    $jpp->get_section('package','components')->subst_if('lucene22','lucene',qr'Requires');
    $jpp->get_section('package','')->subst_if('apacheds10-core','apacheds-core',qr'Requires');
    $jpp->get_section('package','')->subst_if('maven-atrefact-ant','maven-ant-tasks',qr'Requires');
# TODO as a hook
#    $jpp->get_section('prep')->unshift_body2_before(q!
#diff     portals-jetspeed2-maven-plugin-project.patch{~,}
#27c27
#< +            <jar>apacheds10/core.jar</jar>
#> +            <jar>apacheds/core.jar</jar>

    $jpp->get_section('package','')->unshift_body('BuildRequires: rome'."\n");
    $jpp->get_section('build')->unshift_body2_before(q!
mvn-jpp -e \
         -s ${M2SETTINGS} \
         -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
         -Dmaven2.jpp.depmap.file=%{SOURCE2} \
       install:install-file -DgroupId=rome -DartifactId=rome \
         -Dversion=0.8 -Dpackaging=jar -Dfile=$(build-classpath rome-0.9)
mvn-jpp -e \
         -s ${M2SETTINGS} \
         -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
         -Dmaven2.jpp.depmap.file=%{SOURCE2} \
       install:install-file -DgroupId=lucene -DartifactId=lucene-core \
         -Dversion=2.0.0 -Dpackaging=jar -Dfile=$(build-classpath lucene)
!,qr'mvn-jpp');

    #ln -s %{name}-api-%{version} $RPM_BUILD_ROOT%{_javadocdir}/%{name} # ghost symlink
    $jpp->get_section('install')->subst(qr'ln -s \%{name}-api-\%{version}','ln -s %{name}-%{version}');
    #$jpp->get_section('files','javadoc')->subst(qr'ln -s \%{name}-api-\%{version}','#ln -s %{name}-%{version}');
};
__END__
