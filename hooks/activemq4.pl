#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: rome'."\n");

    $jpp->get_section('build')->unshift_body_before(qr'mvn-jpp',q!
mvn-jpp \
        -e \
        -s $SETTINGS \
        -Dtest=false \
        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        install:install-file -DgroupId=rome -DartifactId=rome \
        -Dversion=0.8 -Dpackaging=jar -Dfile=$(build-classpath rome-0.9)
!);


};
__END__
