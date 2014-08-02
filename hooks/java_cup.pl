#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q!Provides: java_cup = %{epoch}:%{version}-%release!."\n");
    $jpp->get_section('install')->push_body(q!# jpp compat
ln -s java_cup-runtime.jar %buildroot%_javadir/java-cup-runtime.jar
ln -s java_cup.jar %buildroot%_javadir/java-cup.jar
!."\n");

#    $jpp->get_section('files')->push_body(q!# jpp compat
#%_javadir/java-cup-runtime.jar
#%_javadir/java-cup.jar
#!."\n");
};

__END__
