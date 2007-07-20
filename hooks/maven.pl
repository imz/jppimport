#!/usr/bin/perl -w

require 'set_fix_jakarta_commons_cli.pl';
#require 'set_target_14.pl';

# added aspectj

$spechook = sub {
    my ($jpp, $alt) = @_;
    # quote bugs
    $jpp->get_section('prep')->subst(qr'%{SOURCE1}','%%{SOURCE1}');

#Следующие пакеты имеют неудовлетворенные зависимости:
#  maven: Требует: /etc/mavenrc но пакет не может быть установлен
    $jpp->get_section('package','')->unshift_body('AutoReq: nosh'."\n");


    $jpp->disable_package('plugin-jalopy');
    $jpp->disable_package('plugin-aspectj');
    $jpp->disable_package('plugin-release');
    $jpp->disable_package('plugin-dashboard');
    $jpp->disable_package('plugin-eclipse');
#    $jpp->disable_package('plugin-latka');    # latka
    $jpp->disable_package('plugin-modello');   # modello w/maven
    $jpp->disable_package('plugin-genapp');    # hivemind
    $jpp->disable_package('plugin-scm'); # maven-scm
    $jpp->disable_package('plugin-tjdo');    # tjdo
    $jpp->disable_package('plugin-wizard'); # jakarta-commons-jelly-tags-swing

    $jpp->get_section('build')->unshift_body(qq{
subst 's,-classpath "${MAVEN_HOME}/lib/\[forehead\].jar",-classpath "${MAVEN_HOME}/lib/[forehead].jar":"${MAVEN_HOME}/lib/forehead.jar",' ../maven/src/bin/maven
subst 's,\]\.jar,.jar,' ../maven/src/bin/forehead.conf
subst 's,lib/\[,lib/,' ../maven/src/bin/forehead.conf
subst 's,ant\]/\[,,' ../maven/src/bin/forehead.conf
});

    $jpp->get_section('prep')->push_body(qq{
rm -r ../maven-plugins/jalopy
rm -r ../maven-plugins/aspectj
# tests fails
rm -r ../maven-plugins/dashboard
# dashboard:findbugs javancss
rm -r ../maven-plugins/eclipse
rm -r ../maven-plugins/genapp
rm -r ../maven-plugins-sandbox/modello
rm -r ../maven-plugins-sandbox/release
rm -r ../maven-plugins-sandbox/tjdo
rm -r ../maven-plugins-sandbox/wizard
});

}



__END__
./build-maven-library
# handmade fix! should be just after ./build-maven-library! merge in 1 line?
build-jar-repository home/lib commons-jelly-tags-jsl

at %build begin
## forehead.conf hack: #######
cp ../maven/src/bin/forehead.conf ../maven/src/bin/forehead.conf.untouched
### end forehead.conf hack ###

at %install end
## forehead.conf hack: #######
#cat ../maven/src/bin/forehead.conf.untouched > $RPM_BUILD_ROOT%{_datadir}/%{name}/bin/forehead.conf
### end forehead.conf hack ###
# new hack ###################
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


AutoReq: nosh
Следующие пакеты имеют неудовлетворенные зависимости:
  maven: Требует: /etc/mavenrc но пакет не может быть установлен


    # bootstrap :)
    $jpp->get_section('package','')->subst(qr'define RHEL4 0','define RHEL4 1');
    # fix it!
    $jpp->get_section('package','plugin-aspectwerkz')->subst(qr'gnu-trove','gnu.trove');

#    $jpp->get_section('build')->replace_line('echo "maven.plugins.excludes = examples/**,touchstone/**,touchstone-partner/**,plugin-parent/**,itest/**,abbot/**,ashkelon/**,aspectj/**,aspectwerkz/**,changelog/**,clover/**,hibernate/**,jalopy/**,jdeveloper/**,jdiff/**,jetty/**,latex/**,latka/**,native/**,pdf/**,simian/**,tjdo/**,uberjar/**,vdoclet/**" >> project.properties'."\n", 'echo "maven.plugins.excludes = examples/**,touchstone/**,touchstone-partner/**,plugin-parent/**,itest/**,abbot/**,ashkelon/**,aspectj/**,aspectwerkz/**,changelog/**,clover/**,hibernate/**,jalopy/**,jdeveloper/**,jdiff/**,jetty/**,latex/**,latka/**,native/**,pdf/**,simian/**,tjdo/**,uberjar/**,vdoclet/**,genapp/**,html2xdoc/**,scm/**,xdoc/**,jcoverage/**,junitdoclet/**,wizard/**" >> project.properties'."\n");


    # ALT Compat provides
    # hack around alt ant deps
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-bcel','BuildRequires: ant-bcel');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-oro','BuildRequires: ant-jakarta-oro');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-regexp','BuildRequires: ant-jakarta-regexp');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-log4j','BuildRequires: ant-log4j');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-bcel','BuildRequires: ant-bcel');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-resolver','BuildRequires: ant-xml-resolver');
