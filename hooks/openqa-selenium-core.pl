#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->unshift_body('BuildRequires: rhino'."\n");
}
__END__
mvn-jpp -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5 \
        -e \
        -s $(pwd)/settings.xml \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        -Dmaven2.jpp.depmap.file=%{SOURCE1} \
        install:install-file -DgroupId=bouncycastle -DartifactId=bcprov-jdk15 -Dversion=135 -Dpackaging=jar -Dfile=$(build-classpath bcprov)
