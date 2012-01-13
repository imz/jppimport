#!/usr/bin/perl -w

require 'windows-thumbnail-database-in-package.pl';
__END__

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jboss4-common qdox'."\n");
    $jpp->get_section('build')->subst(qr'build-classpath ejb\)','build-classpath ejb_2_1_api)');
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-jms-1.1-api'."\n");
};
__END__
___STRUTS1.3__
+BuildRequires: struts-tiles struts-taglib
--- spring.spec.0       2009-05-21 15:32:56 +0000
+++ spring.spec 2009-05-21 15:57:56 +0000
@@ -2,6 +2,7 @@
@@ -639,6 +640,9 @@
 mkdir -p struts
 pushd struts
 ln -sf $(build-classpath struts) struts.jar
+ln -sf $(build-classpath struts-extras) struts-extras.jar
+ln -sf $(build-classpath struts-taglib) struts-taglib.jar
+ln -sf $(build-classpath struts-tiles) struts-tiles.jar
 popd

 mkdir -p velocity
@@ -656,11 +660,14 @@
 export OPT_JAR_LIST="ant-launcher ant/ant-junit junit xjavadoc commons-collections commons-attributes-compiler qdox"
 #export ANT_OPTS="-Dmx4j.log.priority=debug"
+for i in `find . -name build.xml`; do subst 's,name="struts.jar",name="struts*.jar",' $i; done

 ant \
     -Djava.endorsed.dir=lib/endorsed \
-    alljars tests
+    alljars #tests

