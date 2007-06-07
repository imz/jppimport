#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # ALT Compat provides
    # hack around alt ant deps
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-bcel','BuildRequires: ant-bcel');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-oro','BuildRequires: ant-jakarta-oro');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-regexp','BuildRequires: ant-jakarta-regexp');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-log4j','BuildRequires: ant-log4j');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-bcel','BuildRequires: ant-bcel');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-resolver','BuildRequires: ant-xml-resolver');

    # quite bugs
    $jpp->get_section('prep')->subst(qr'%{SOURCE1}','%%{SOURCE1}');

    # bug:
    # disabled in bootstrap
#%files plugin-latka
#%dir %{_datadir}/%{name}
#%dir %{_datadir}/%{name}/plugins
#%{_datadir}/%{name}/plugins/maven-latka-plugin*.jar
#%{_javadir}/%{name}-plugins/maven-latka-plugin.jar
    my $latkasec=$jpp->get_section('files','plugin-latka');
    $latkasec->unshift_body_before_section('%if %{RHEL4}==0'."\n");
    $latkasec->push_body('%endif'."\n");

    # bootstrap :)
    $jpp->get_section('package','')->subst(qr'define RHEL4 0','define RHEL4 1');

    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*jakarta-commons-cli','BuildRequires: jakarta-commons-cli-1');

    $jpp->disable_package('plugin-genapp');    # hivemind
    $jpp->disable_package('plugin-html2xdoc'); # jakarta-commons-jelly-tags-html2xdoc
    $jpp->disable_package('plugin-jcoverage'); # plugin-jcoverage
    $jpp->disable_package('plugin-junitdoclet'); # junitdoclet-jdk14
    $jpp->disable_package('plugin-scm'); # maven-scm
    $jpp->disable_package('plugin-wizard'); # jakarta-commons-jelly-tags-swing
    $jpp->disable_package('plugin-xdoc'); # jakarta-commons-jelly-tags-fmt

    $jpp->get_section('build')->replace_line('echo "maven.plugins.excludes = examples/**,touchstone/**,touchstone-partner/**,plugin-parent/**,itest/**,abbot/**,ashkelon/**,aspectj/**,aspectwerkz/**,changelog/**,clover/**,hibernate/**,jalopy/**,jdeveloper/**,jdiff/**,jetty/**,latex/**,latka/**,native/**,pdf/**,simian/**,tjdo/**,uberjar/**,vdoclet/**" >> project.properties'."\n", 'echo "maven.plugins.excludes = examples/**,touchstone/**,touchstone-partner/**,plugin-parent/**,itest/**,abbot/**,ashkelon/**,aspectj/**,aspectwerkz/**,changelog/**,clover/**,hibernate/**,jalopy/**,jdeveloper/**,jdiff/**,jetty/**,latex/**,latka/**,native/**,pdf/**,simian/**,tjdo/**,uberjar/**,vdoclet/**,genapp/**,html2xdoc/**,scm/**,xdoc/**,jcoverage/**,junitdoclet/**,wizard/**" >> project.properties'."\n");
}
__END__
#BuildRequires: ant-apache-resolver >= 0:1.6.2
#BuildRequires: ant-nodeps
#BuildRequires: dom4j >= 0:1.5-1jpp
#BuildRequires: forehead >= 0:1.0.b4-4jpp
#BuildRequires: jakarta-commons-beanutils16 >= 0:1.6.1
#BuildRequires: jakarta-commons-betwixt >= 0:1.0-0.alpha1.4jpp
#BuildRequires: jakarta-commons-cli >= 1.0
#BuildRequires: jakarta-commons-collections >= 0:3.1-1jpp
# semi
#BuildRequires: jakarta-commons-digester >= 0:1.7
#BuildRequires: jakarta-commons-grant >= 0:1.0.b4
#BuildRequires: jakarta-commons-graph >= 0:0.8.1
#BuildRequires: jakarta-commons-httpclient >= 2.0
#BuildRequires: jakarta-commons-io >= 1.1
-BuildRequires: jakarta-commons-jelly >= 0:1.0-0.b4.6jpp
-BuildRequires: jakarta-commons-jelly-tags-ant >= 0:1.0-0.b4.6jpp
-BuildRequires: jakarta-commons-jelly-tags-define >= 0:1.0-0.b4.6jpp
-BuildRequires: jakarta-commons-jelly-tags-util >= 0:1.0-0.b4.6jpp
-BuildRequires: jakarta-commons-jelly-tags-xml >= 0:1.0-0.b4.6jpp
#BuildRequires: jakarta-commons-jexl >= 0:1.0
#BuildRequires: jakarta-commons-logging >= 0:1.0.3
#BuildRequires: jline >= 0.8.1
#BuildRequires: jaxen >= 0:1.1
#BuildRequires: junit >= 0:3.8.1
-BuildRequires: log4j >= 0:1.2.8
#BuildRequires: maven-model >= 3.0.1
-BuildRequires: maven-wagon >= 1.0
#BuildRequires: plexus-container-default >= 0:1.0
#BuildRequires: plexus-utils >= 1.0.4
#BuildRequires: plexus-velocity >= 0:1.1.2
#BuildRequires: werkz >= 1.0-0.b10.5jpp
#BuildRequires: xerces-j2 >= 0:2.6.2
#Requires: xml-commons-apis
#Requires: xml-commons-which
