#!/usr/bin/perl -w

push @SPECHOOKS, 

sub  {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-poi'."\n");
};

sub old_hacks {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->unshift_body_before(q!
#ln -sf $(build-classpath commons-lang) .maven/repository/JPP/

mkdir -p .maven/repository/JPP/plugins/
ln -s \
/usr/share/java/maven-plugins/maven-xdoc-plugin.jar \
/usr/share/java/maven-plugins/maven-tasks-plugin.jar \
/usr/share/java/maven-plugins/maven-findbugs-plugin.jar \
/usr/share/java/maven-plugins/maven-cobertura-plugin.jar \
/usr/share/java/maven-plugins/maven-changes-plugin.jar \
/usr/share/java/maven-plugins/maven-scm-plugin.jar \
/usr/share/java/maven-plugins/maven-jdiff-plugin.jar \
.maven/repository/JPP/plugins/
!, qr'^maven');
}

