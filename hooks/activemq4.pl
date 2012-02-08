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
# jpp5
    $jpp->add_patch('activemq4-4.1.2-alt-pom-use-maven2-plugin-shade.patch',STRIP=>1);
    $jpp->get_section('package','')->subst_if('mojo-maven2-plugin-shade','maven2-plugin-shade',qr'Requires:');
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-jacc-1.0-api geronimo-jms-1.1-api geronimo-specs javacc3 rome tomcat5-servlet-2.4-api'."\n");
    $jpp->get_section('package','')->subst(qr'Requires: smack','Requires: smack1');
    $jpp->get_section('package','')->subst_if(qr'apacheds10','apacheds','Requires:');
    $jpp->get_section('package','')->subst_if(qr'primitives11','primitives','Requires:');
    # TODO + subst in activemq4-jpp-depmap.xml    
    $jpp->get_section('package','xmpp')->subst(qr'Requires: smack','Requires: smack1');

    $jpp->get_section('build')->unshift_body_before(qr'mvn-jpp',q!
mvn-jpp \
        -e \
        -s $SETTINGS \
        -Dtest=false \
        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        install:install-file -DgroupId=javacc -DartifactId=javacc \
        -Dversion=3.2 -Dpackaging=jar -Dfile=$(build-classpath javacc3)
!);

}
__END__
# maven 208
install -Dm644 %{SOURCE3} $MAVEN_REPO_LOCAL/org/apache/apache-jar-resource-bundle/1.4/apache-jar-resource-bundle-1.4.jar
415a416,417
>       -Dmaven.test.skip=true \
>       -Dmaven.test.skip.exec=true \
in install

diff activemq4-jpp-depmap.xml.old activemq4-jpp-depmap.xml    
453c453
<      <artifactId>smackx</artifactId>
---
>      <artifactId>smackx1</artifactId>
465c465
<      <artifactId>smack</artifactId>
---
>      <artifactId>smack1</artifactId>
