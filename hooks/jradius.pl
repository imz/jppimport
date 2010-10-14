#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: myfaces'."\n");
    $jpp->get_section('build')->subst(qr'128M', '256M');
    $jpp->get_section('build')->subst(qr'classpath bouncycastle/bcprov', 'classpath bcprov');
}

__END__
mvn-jpp -e \
        -s ${M2SETTINGS} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
        install:install-file -DgroupId=bouncycastle -DartifactId=bcprov-jdk15 -Dversion=140 -Dpackaging=jar -Dfile=/usr/share/java/bcprov.jar
