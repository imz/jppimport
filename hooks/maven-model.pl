#!/usr/bin/perl -w

# misses org/apache/maven/project/io/stax/MavenStaxReader in resulting jar :(
#require 'set_with_maven.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->spec_apply_patch(PATCHSTRING=>q!
--- maven-model.spec	2012-02-08 19:15:42.851762358 +0000
+++ maven-model.spec	2012-02-08 19:16:49.591761985 +0000
@@ -150,6 +150,8 @@
 plexus/containers-container-default \
 plexus/utils \
 stax-utils \
+google-collections \
+xbean/xbean-reflect \
 )
 
 java org.codehaus.modello.ModelloCli src/main/mdo/maven.mdo java target/generated-sources 4.0.0 false true
!)
};

__END__
