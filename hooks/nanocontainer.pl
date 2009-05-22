#!/usr/bin/perl -w

require 'set_excalibur_pom.pl';

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

__END__
341,342c351,352
< install -pm 644 container-jruby/target/%{name}-jruby-%{version}.jar \
<   $RPM_BUILD_ROOT%{_javadir}/%{name}/container-jruby-%{version}.jar
---
> #install -pm 644 container-jruby/target/%{name}-jruby-%{version}.jar \
> #  $RPM_BUILD_ROOT%{_javadir}/%{name}/container-jruby-%{version}.jar
345,346c355,356
< install -pm 644 container-rhino/target/%{name}-rhino-%{version}.jar \
<   $RPM_BUILD_ROOT%{_javadir}/%{name}/container-rhino-%{version}.jar
---
> #install -pm 644 container-rhino/target/%{name}-rhino-%{version}.jar \
> #  $RPM_BUILD_ROOT%{_javadir}/%{name}/container-rhino-%{version}.jar
353,354c363,364
< install -pm 644 webcontainer/target/%{name}-webcontainer-%{version}.jar \
<   $RPM_BUILD_ROOT%{_javadir}/%{name}/webcontainer-%{version}.jar
---
> #install -pm 644 webcontainer/target/%{name}-webcontainer-%{version}.jar \
> #  $RPM_BUILD_ROOT%{_javadir}/%{name}/webcontainer-%{version}.jar
440c450
< cp -pr container-jruby/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/container-jruby
---
> #cp -pr container-jruby/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/container-jruby
444c454
< cp -pr container-rhino/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/container-rhino
---
> #cp -pr container-rhino/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/container-rhino
453c463
< cp -pr webcontainer/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/webcontainer
---
> #cp -pr webcontainer/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/webcontainer
461c471
< cp -pr target/site $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}
---
> #cp -pr target/site $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}
