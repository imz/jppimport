#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->subst_if(qr'lucene22','lucene',qr'Requires:');
};

__END__
mvn-jpp -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5  -e \
        -s ${M2SETTINGS} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
        install:install-file -DgroupId=bouncycastle -DartifactId=bcprov-jdk14 -Dversion=136 -Dpackaging=jar -Dfile=$(build-classpath bcprov)

mvn-jpp -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5  -e \
        -s ${M2SETTINGS} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
        install:install-file -DgroupId=bouncycastle -DartifactId=bcmail-jdk14 -Dversion=136 -Dpackaging=jar -Dfile=$(build-classpath bcmail)

mvn-jpp -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5  -e \
        -s ${M2SETTINGS} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
        install:install-file -DgroupId=org.jempbox -DartifactId=jempbox -Dversion=0.2.0 -Dpackaging=jar -Dfile=/usr/share/java/maven2/empty-dep.jar
