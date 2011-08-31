#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    $jpp->get_section('install')->push_body('
#Требует: /usr/share/maven/home/plugins/maven-changes-plugin-1.7.jar
#Требует: /usr/share/maven/home/plugins/maven-jcoverage-plugin-1.1-SNAPSHOT.jar
#broken symlinks (jpp 5.0/6.0 to report)
#/usr/share/maven/repository/maven/jars/maven-changes-plugin-1.7.jar
#/usr/share/maven/repository/maven/plugins/maven-jcoverage-plugin-1.0.9.jar
pushd %buildroot/usr/share/maven
ln -sf ../../../plugins/maven-changes-plugin-1.7.jar repository/maven/jars/maven-changes-plugin-1.7.jar
ln -sf ../../../plugins/maven-jcoverage-plugin-1.1-SNAPSHOT.jar repository/maven/plugins/maven-jcoverage-plugin-1.0.9.jar
popd
');

    # plexus-*have component-api.jar no more, use containers-container-default.jar instead.
    # other way is to fix maven-plugins-r565288.patch
    $jpp->get_section('prep')->push_body(q!
# plexus-* have component-api.jar no more, use containers-container-default.jar instead.
sed -i 's,<jar>plexus/component-api.jar</jar>,<jar>plexus/containers-container-default.jar</jar>,' ../maven-plugins/scm/project.xml
sed -i 's,<jar>plexus/containers-component-api.jar</jar>,<jar>plexus/containers-container-default.jar</jar>,' ../maven-plugins/modello/project.xml
!);

    $jpp->add_patch('maven-1.1-plugin-checkstyle-alt-add-collections-dep.patch', STRIP=>0);

    # TODO: report against 1.1 -9jpp -- split macro; as always :(
#:0}%{!?_without_bootstrap:%{?_bootstrap:%{_bootstrap}}%{!?_bootstrap:0}}}
    $jpp->get_section('package','')->subst(qr'%define bootstrap %{\?_with_bootstrap:1}%{!\?_with_bootstrap:%{\?_without_bootstrap\s*','%define bootstrap %{?_with_bootstrap:1}%{!?_with_bootstrap:%{?_without_bootstrap');

#Следующие пакеты имеют неудовлетворенные зависимости:
#  maven: Требует: /etc/mavenrc но пакет не может быть установлен
    &add_missingok_config($jpp,'/etc/mavenrc');

# hack, according to current policy :(
#l ./share/maven/repository/javadoc/jars
#lrwxrwxrwx 1 igor igor 37 Мар 19 20:57 tools.jar -> /usr/lib/jvm/java-1.5.0/lib/tools.jar
    $jpp->get_section('package','')->unshift_body('%add_findreq_skiplist %_datadir/maven/repository/javadoc/jars/*'."\n");
};

__END__
#5.0
    $jpp->get_section('package','')->unshift_body('

#/usr/bin/build-jar-repository: error: Could not find commons-betwixt Java extension for this JVM
#/usr/bin/build-jar-repository: error: Could not find commons-digester Java extension for this JVM
#/usr/bin/build-jar-repository: error: Could not find commons-jelly-tags-interaction Java extension for this JVM
#/usr/bin/build-jar-repository: error: Could not find xml-commons-which Java extension for this JVM
Requires: jakarta-commons-digester jakarta-commons-betwixt jakarta-commons-jelly-tags-interaction xml-commons-which
# to proceed w/builds

# not too required, but suppress the warnings above during build
BuildRequires: jakarta-commons-digester jakarta-commons-betwixt jakarta-commons-jelly-tags-interaction xml-commons-which

# do required
BuildRequires: jakarta-commons-digester
BuildRequires: jakarta-commons-jelly-tags-http
');

#    $jpp->disable_package('plugin-aspectj');
#    $jpp->disable_package('plugin-release');
#    $jpp->disable_package('plugin-dashboard');
#    $jpp->disable_package('plugin-eclipse');

    $jpp->get_section('package','')->push_body(q!# eclipse plugin requirements (removed eclipse-pde)
BuildRequires: jakarta-cactus eclipse

# TODO: kill
#    $jpp->get_section('pre','');

!);

__END__
