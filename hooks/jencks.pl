#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-jms-1.1-api javacc3'."\n");
    $jpp->get_section('build')->unshift_body_before(qr'mvn-jpp',q!
mvn-jpp \
        -e \
        -s ${M2SETTINGS} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        -Dmaven2.jpp.depmap.file=%{SOURCE1} \
        install:install-file -DgroupId=javacc -DartifactId=javacc \
        -Dversion=3.2 -Dpackaging=jar -Dfile=$(build-classpath javacc3)
!);

}
__END__
