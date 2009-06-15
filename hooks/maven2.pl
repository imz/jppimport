#!/usr/bin/perl -w

#require 'set_bootstrap.pl';
require 'set_target_14.pl';
#require 'set_without_maven.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('BuildRequires: avalon-framework'."\n");
    $jpp->get_section('package','plugin-idea')->subst('dom4j >= 1.6.1','dom4j >= 0:1.6.1');
    # due to
  # Requires: dom4j >= 1.6.1
  # Requires: dom4j >= 0:1.6.1

    $jpp->get_section('build')->unshift_body_before('
# avalon hack
$M2_HOME/bin/mvn -s %{maven_settings_file} $MAVEN_OPTS \
      install:install-file -DgroupId=avalon-framework -DartifactId=avalon-framework \
      -Dversion=4.1.3 -Dpackaging=jar -Dfile=$(build-classpath avalon-framework)

',qr'# Build everything');
};

__END__






__DATA__
# 2.0.7; no more used
@@ -1392,6 +1393,11 @@
 mkdir -p maven-assembly-plugin/target/generated-resources/plexus/META-INF/plexus/
 echo '<component-set/>' > maven-assembly-plugin/target/generated-resources/plexus/META-INF/plexus/components.xml
 
+# avalon hack
+$M2_HOME/bin/mvn -s %{maven_settings_file} $MAVEN_OPTS \
+      install:install-file -DgroupId=avalon-framework -DartifactId=avalon-framework \
+      -Dversion=4.1.3 -Dpackaging=jar -Dfile=$(build-classpath avalon-framework)
+
 # Build everything
 $M2_HOME/bin/mvn -e --batch-mode -s %{maven_settings_file} $MAVEN_OPTS -npu --no-plugin-registry --fail-at-end install
