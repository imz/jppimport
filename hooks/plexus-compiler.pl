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

    # 1.5.2 from jpackage 1.7
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-surefire'."\n");
    $jpp->get_section('build')->unshift_body_after('-Dmaven.test.skip=true \\', qr'mvn-jpp');
