#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
}

__END__
mvn-jpp -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5  \
        -e \
        -s $MAVEN_SETTINGS \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        -Dmaven2.jpp.depmap.file=%{SOURCE1} \
        install:install-file -DgroupId=bouncycastle -DartifactId=bcprov-jdk15 -Dversion=135 -Dpackaging=jar -Dfile=$(build-classpath bcprov)

mvn-jpp -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5  \
        -e \
        -s $MAVEN_SETTINGS \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        -Dmaven2.jpp.depmap.file=%{SOURCE1} \
       install:install-file -DgroupId=org.testng -DartifactId=testng -Dversion=5.8 -Dclassifier=jdk15 -Dpackaging=jar -Dfile=$(build-classpath testng-jdk15)
