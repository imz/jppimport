#!/usr/bin/perl -w

#require 'set_bootstrap.pl';
require 'set_target_14.pl';
require 'set_without_maven.pl';

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
# 2.0.7
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
 



# 2.0.4

    foreach my $section ($jpp->get_sections()) {
	if ($section->get_type() eq 'package') {
	    #$section->subst(qr'maven-scm\s*>=\s*0:1.0-0.b3.2','maven-scm ');
	}
    }

    $jpp->get_section('package','')->subst(qr'gnu\.regexp','gnu-regexp');
    $jpp->get_section('package','')->subst(qr'BuildRequires: modello-maven-plugin','##BuildRequires: modello-maven-plugin');
    $jpp->get_section('package','')->push_body('BuildRequires: checkstyle-optional jmock'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: saxon-scripts'."\n");
    #$jpp->get_section('package','')->push_body('BuildRequires: maven2-bootstrap-bundle'."\n");
    $jpp->get_section('build')->subst(qr'/%3','/[%%]3');
    $jpp->get_section('build')->subst(qr'%3e','/[%%]3e');

    $jpp->add_patch('maven2-2.0.4-MANTTASKS-44.diff');
# DONE in 11jpp
#    $jpp->get_section('prep')->push_body('%__subst "s,import org.jmock.cglib.Mock,import org.jmock.Mock," maven2-plugins/maven-release-plugin/src/test/java/org/apache/maven/plugins/release/PrepareReleaseMojoTest.java'."\n");

    # to avoid dependency on maven via /etc/mavenrc
    $jpp->get_section('package','')->push_body('%add_findreq_skiplist /usr/share/maven2/bin/mvn'."\n");

    # helped to fix build for maven2-2.0.4-11jpp
    $jpp->get_section('build')->unshift_body_after(q!
###################################
###################################
for i in /usr/share/maven2/default_poms/*.pom /usr/share/maven2/poms/*.pom; do
        [ -e m2_repo/repository/JPP/maven2/default_poms/`basename $i` ] || ln -s $i m2_repo/repository/JPP/maven2/default_poms/
done
###################################
###################################
!, qr!export M2_HOME=`pwd`/maven2/home!);
