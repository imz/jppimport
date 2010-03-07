#!/usr/bin/perl -w

require 'set_maven_notests.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # bug to report
    $jpp->get_section('install')->subst(qr'ln -sf %{_javadir}/nanocontainer-booter.jar','ln -sf %{_javadir}/nanocontainer/booter.jar');
}

__END__


push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body(q!BuildRequires: mojo-maven2-plugin-cobertura cobertura maven2-default-skin jetty6-core jetty6-jsp-2.0-api jetty6-servlet-2.5-api slf4j
!);
    # bug to report
    $jpp->get_section('install')->subst(qr'ln -sf %{_javadir}/nanocontainer-booter.jar','ln -sf %{_javadir}/nanocontainer/booter.jar');

    # problems with site
    $jpp->disable_package('manual');
    $jpp->get_section('build')->subst(qr'install javadoc:javadoc site:site','install javadoc:javadoc');

    # upstream is dead, code does not complie with fresh rhino && jruby, etc
    #$jpp->disable_package('container-aop');
    #$jpp->disable_package('container-bsh');
    #$jpp->disable_package('container-groovy');
    $jpp->disable_package('container-jruby');
    #$jpp->disable_package('container-jython');
    $jpp->disable_package('container-rhino');
    $jpp->disable_package('webcontainer');
    $jpp->add_patch('nanocontainer-1.1-alt-disable-containers.patch');
    $jpp->get_section('prep')->push_body(q!
subst 's,<module>container-jruby</module>,,' pom.xml
subst 's,<module>container-rhino</module>,,' pom.xml
subst 's,<module>webcontainer</module>,,' pom.xml
!);

    # deciphering is below
    $jpp->get_section('install')->exclude(qr'(-jruby|-rhino|webcontainer-|/webcontainer|target/site)');
}

