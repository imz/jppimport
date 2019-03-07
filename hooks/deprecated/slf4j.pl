#!/usr/bin/perl -w

require 'set_manual_no_dereference.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
#    $spec->get_section('install')->push_body(q!# compat for jpp
#pushd %buildroot%{_javadir}/slf4j
#for i in *.jar; do
#        ln -s $i slf4j-$i
#done
#!."\n");

#    $spec->get_section('files')->push_body(q!
#%{_javadir}/slf4j/api.jar
#%{_javadir}/slf4j/jdk14.jar
#%{_javadir}/slf4j/nop.jar
#!."\n");
};

__END__
