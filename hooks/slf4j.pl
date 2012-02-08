#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body(q!# tmp compat for terracotta-dso bootstrap
ln -s slf4j-api.jar %buildroot%{_javadir}/slf4j/api.jar
ln -s slf4j-jdk14.jar %buildroot%{_javadir}/slf4j/jdk14.jar
ln -s slf4j-nop.jar %buildroot%{_javadir}/slf4j/nop.jar
!."\n");

    $jpp->get_section('files')->push_body(q!
%{_javadir}/slf4j/api.jar
%{_javadir}/slf4j/jdk14.jar
%{_javadir}/slf4j/nop.jar
!."\n");
};

__END__
