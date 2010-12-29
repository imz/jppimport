#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
};
__END__

    $jpp->get_section('package','')->unshift_body('BuildRequires: saxpath xmlgraphics-batik-svgpp xmlgraphics-batik-rasterizer xmlgraphics-batik-slideshow xmlgraphics-batik-squiggle xmlgraphics-batik-ttf2svg'."\n");
    $jpp->get_section('build')->unshift_body_before(q!
mvn-jpp install:install-file \
    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
    -s $M2_SETTINGS \
    -DgroupId=org.apache.xmlgraphics \
    -DartifactId=batik-svg-dom \
    -Dversion=1.7 \
    -Dpackaging=jar \
    -Dfile=$(build-classpath xmlgraphics-batik/svg-dom)

mvn-jpp install:install-file \
    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
    -s $M2_SETTINGS \
    -DgroupId=org.apache.xmlgraphics \
    -DartifactId=batik-bridge \
    -Dversion=1.7 \
    -Dpackaging=jar \
    -Dfile=$(build-classpath xmlgraphics-batik/bridge)

mvn-jpp install:install-file \
    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
    -s $M2_SETTINGS \
    -DgroupId=org.apache.xmlgraphics \
    -DartifactId=batik-gvt \
    -Dversion=1.7 \
    -Dpackaging=jar \
    -Dfile=$(build-classpath xmlgraphics-batik/gvt)

mvn-jpp install:install-file \
    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
    -s $M2_SETTINGS \
    -DgroupId=org.apache.xmlgraphics \
    -DartifactId=batik-ext \
    -Dversion=1.7 \
    -Dpackaging=jar \
    -Dfile=$(build-classpath xmlgraphics-batik/ext)

mvn-jpp install:install-file \
    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
    -s $M2_SETTINGS \
    -DgroupId=org.apache.xmlgraphics \
    -DartifactId=batik-awt-util \
    -Dversion=1.7 \
    -Dpackaging=jar \
    -Dfile=$(build-classpath xmlgraphics-batik/awt-util)

mvn-jpp install:install-file \
    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
    -s $M2_SETTINGS \
    -DgroupId=org.apache.xmlgraphics \
    -DartifactId=batik-transcoder \
    -Dversion=1.7 \
    -Dpackaging=jar \
    -Dfile=$(build-classpath xmlgraphics-batik/transcoder)

mvn-jpp install:install-file \
    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
    -s $M2_SETTINGS \
    -DgroupId=org.apache.xmlgraphics \
    -DartifactId=batik-extension \
    -Dversion=1.7 \
    -Dpackaging=jar \
    -Dfile=$(build-classpath xmlgraphics-batik/extension)
!,qr'mvn-jpp');

};
