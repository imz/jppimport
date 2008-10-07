#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # bug to report in jpp5  (sux4j-1.0.3-alt1_1jpp5)
    $jpp->get_section('package','')->unshift_body('BuildRequires: fastutil5 dsiutils colt jsap log4j'."\n");
};

__END__
/usr/bin/build-classpath: error: Could not find fastutil5 Java extension for thi
s JVM
/usr/bin/build-classpath: error: Could not find dsiutils Java extension for this
 JVM
/usr/bin/build-classpath: error: Could not find colt Java extension for this JVM
/usr/bin/build-classpath: error: Could not find jsap Java extension for this JVM
/usr/bin/build-classpath: error: Could not find log4j Java extension for this JVM
