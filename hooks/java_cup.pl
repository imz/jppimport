#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q!Obsoletes: java-cup < 2:11b
Provides: java-cup = %{epoch}:%{version}-%release!."\n");
};

__END__
    $jpp->get_section('install')->push_body(q!# jpp compat
ln -s java_cup-runtime.jar %buildroot%_javadir/java-cup-runtime.jar
ln -s java_cup.jar %buildroot%_javadir/java-cup.jar
!."\n");

#    $jpp->get_section('files')->push_body(q!# jpp compat
#%_javadir/java-cup-runtime.jar
#%_javadir/java-cup.jar
#!."\n");
