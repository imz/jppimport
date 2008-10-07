#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # bug to report in jpp5  (dsiutils-1.0.7-alt1_1jpp5)
    $jpp->get_section('package','')->unshift_body('BuildRequires: fastutil5 colt jsap jakarta-commons-lang jakarta-commons-io jakarta-commons-collections jakarta-commons-configuration'."\n");
};

__END__
/usr/bin/build-classpath: error: Could not find fastutil5 Java extension for this JVM
/usr/bin/build-classpath: error: Could not find colt Java extension for this JVM
/usr/bin/build-classpath: error: Could not find jsap Java extension for this JVM
/usr/bin/build-classpath: error: Could not find jakarta-commons-lang Java extension for this JVM
/usr/bin/build-classpath: error: Could not find jakarta-commons-io Java extension for this JVM
/usr/bin/build-classpath: error: Could not find jakarta-commons-collections Java extension for this JVM
/usr/bin/build-classpath: error: Could not find jakarta-commons-configuration Java extension for this JVM
/usr/bin/build-classpath: error: Some specified jars were not found
