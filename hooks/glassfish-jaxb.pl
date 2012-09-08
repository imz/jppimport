#!/usr/bin/perl -w

#require 'set_fix_repolib_project.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
}

__END__
    $jpp->get_section('package')->push_body(q!
Provides: /usr/share/java/sun-jaxb/jaxb-api.jar
Provides: /usr/share/java/sun-jaxb/jaxb-impl.jar
Provides: /usr/share/java/sun-jaxb/jaxb-xjc.jar
!);

# TODO: remove after jbossas rebuild.
    $jpp->get_section('install')->push_body(q!
# compat symlink
ln -s glassfish-jaxb %buildroot%_javadir/sun-jaxb
!);
    $jpp->get_section('files')->push_body(q!%_javadir/sun-jaxb
!);
