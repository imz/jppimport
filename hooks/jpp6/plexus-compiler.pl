#!/usr/bin/perl -w

require 'set_target_14.pl';
require 'set_without_maven.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
}

__END__
# prep
rm plexus-compilers/plexus-compiler-javac/src/test/java/org/codehaus/plexus/compiler/javac/JavacCompilerTest.java
