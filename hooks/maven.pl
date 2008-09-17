#!/usr/bin/perl -w

# todo: whether it is really required?
#require 'set_target_14.pl';
require 'add_missingok_config.pl';

# added aspectj

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # TODO: report against 1.1 -2jpp -- split macro; as always :(
#:0}%{!?_without_bootstrap:%{?_bootstrap:%{_bootstrap}}%{!?_bootstrap:0}}}
    $jpp->get_section('package','')->subst(qr'%define bootstrap %{\?_with_bootstrap:1}%{!\?_with_bootstrap:%{\?_without_bootstrap\s*','%define bootstrap %{?_with_bootstrap:1}%{!?_with_bootstrap:%{?_without_bootstrap');

    # quote bugs
    $jpp->get_section('prep')->subst(qr'%{SOURCE1}','%%{SOURCE1}');

    #E: Версия >='0:4.3.1' для 'excalibur-avalon-framework-api' не найдена
    foreach my $section (@{$jpp->get_sections_ref()}) {
	if ($section->get_type() eq 'package') {
	    #$section->subst(qr'excalibur-avalon-framework-api\s*>=\s*0:4.3.1','excalibur-avalon-framework-api ');
	    #$section->subst(qr'excalibur-avalon-framework-impl\s*>=\s*0:4.3.1','excalibur-avalon-framework-impl ');
	    #$section->subst(qr'excalibur-avalon-logkit\s*>=\s*0:2.2.1','excalibur-avalon-logkit ');
	}
    }

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
    $jpp->disable_package('plugin-genapp');    # jboss4-server

    $jpp->get_section('package','')->push_body(q!# eclipse plugin requirements (removed eclipse-pde)
BuildRequires: jakarta-cactus eclipse
!);

    # hack around excalibur-bootstrap-bundle
    $jpp->get_section('package','plugin-aspectj')->subst_if(qr'aspectj >= 0:1.2.1','aspectj',qr'Requires:');

    $jpp->get_section('build')->subst(qr'JAVA_HOME=\%{_jvmdir}/java-1.4.2','JAVA_HOME=%{java_home}');
    

    $jpp->get_section('install')->push_body(q!# new hack ###################
cp $RPM_BUILD_ROOT%{_datadir}/%{name}/bin/build-maven-library $RPM_BUILD_ROOT%{_datadir}/%{name}/bin/build-maven-library.orig
grep -v 'exit 0' $RPM_BUILD_ROOT%{_datadir}/%{name}/bin/build-maven-library.orig > $RPM_BUILD_ROOT%{_datadir}/%{name}/bin/build-maven-library
cat >> $RPM_BUILD_ROOT%{_datadir}/%{name}/bin/build-maven-library <<EOF
ln -s /usr/share/java/ant.jar lib/
ln -s /usr/share/java/ant-launcher.jar lib/
ln -s /usr/share/java/ant/ant-junit.jar lib/
ln -s /usr/share/java/commons-logging.jar lib/
ln -s /usr/share/java/log4j.jar lib/
EOF
# end new hack ###############
!);

#Следующие пакеты имеют неудовлетворенные зависимости:
#  maven: Требует: /etc/mavenrc но пакет не может быть установлен
    &add_missingok_config($jpp,'/etc/mavenrc');
    # unmet dep:maven#0:1.1-alt3_0.beta3.2jpp1.7        java-1.4.2-sun-devel
    #$jpp->get_section('package','')->unshift_body('AutoReq: yes,nosymlinks'."\n");
    $jpp->get_section('package','')->unshift_body('%add_findreq_skiplist %_datadir/maven/repository/javadoc/jars/*'."\n");

    $jpp->get_section('build')->unshift_body(q{
subst 's,-classpath "${MAVEN_HOME}/lib/\[forehead\].jar",-classpath "${MAVEN_HOME}/lib/[forehead].jar":"${MAVEN_HOME}/lib/forehead.jar",' ../maven-1.1/src/bin/maven
subst 's,\]\.jar,.jar,' ../maven-1.1/src/bin/forehead.conf
subst 's,lib/\[,lib/,' ../maven-1.1/src/bin/forehead.conf
subst 's,ant\]\[,,' ../maven-1.1/src/bin/forehead.conf


});

    $jpp->get_section('prep')->push_body(qq{
#rm -r ../maven-plugins/{aspectj,dashboard,eclipse}
rm -r ../maven-plugins/genapp
#rm -r ../maven-plugins-sandbox/{modello,release,tjdo,wizard}
});

    $jpp->get_section('build')->push_body_after('build-jar-repository home/lib commons-jelly-tags-jsl'."\n",
						qr'^./build-maven-library');

# TODO: report bug
    $jpp->get_section('install')->push_body(q'
# looks like symlink is added in process of build and is copied mechanically
# gone away in 1.1-2jpp
#rm -f $RPM_BUILD_ROOT/usr/share/maven/repository/maven/jars/maven-j2ee-plugin.jar
# broken symlinks :(
rm -f $RPM_BUILD_ROOT/usr/share/maven/repository/maven/jars/maven-changes-plugin-1.7.jar
rm -f $RPM_BUILD_ROOT/usr/share/maven/repository/maven/plugins/maven-jcoverage-plugin-1.0.9.jar
');

}



__END__
## forehead.conf hack: #######
#cat ../maven/src/bin/forehead.conf.untouched > $RPM_BUILD_ROOT%{_datadir}/%{name}/bin/forehead.conf
### end forehead.conf hack ###
