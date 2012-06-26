#!/usr/bin/perl -w

require 'windows-thumbnail-database-in-package.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
# do we need it? inherited, but not tested with SC03
#    $jpp->get_section('package','')->unshift_body('BuildRequires: avalon-framework'."\n");

};
__END__
current - fixes for old tiles

--- spring2.spec.0	2012-01-20 17:53:05.042587824 +0000
+++ spring2.spec	2012-01-20 19:07:39.150562692 +0000
@@ -1161,13 +1161,13 @@
 ln -sf $(build-classpath jcommander) lib/testng/jcommander.jar
 ln -sf $(build-classpath objenesis) lib/testng/objenesis.jar
 # BUILD/spring/lib/tiles/tiles-api-2.0.6.jar.no
-ln -sf $(build-classpath tiles/api) lib/tiles/tiles-api-2.0.6.jar
+ln -sf $(build-classpath tiles/api) lib/tiles/api-2.0.6.jar
 # BUILD/spring/lib/tiles/tiles-core-2.0.6.jar.no
-ln -sf $(build-classpath tiles/core) lib/tiles/tiles-core-2.0.6.jar
+ln -sf $(build-classpath tiles/core) lib/tiles/core-2.0.6.jar
 # BUILD/spring/lib/tiles/tiles-jsp-2.0.6.jar.no
-ln -sf $(build-classpath tiles/jsp) lib/tiles/tiles-jsp-2.0.6.jar
+ln -sf $(build-classpath tiles/jsp) lib/tiles/jsp-2.0.6.jar
 #
-ln -sf $(build-classpath tiles/servlet) lib/tiles/tiles-servlet-2.0.6.jar
+#ln -sf $(build-classpath tiles/servlet) lib/tiles/tiles-servlet-2.0.6.jar
 # BUILD/spring/lib/tomcat/catalina.jar.no
 ln -sf $(build-classpath tomcat5/catalina) lib/tomcat/catalina.jar
 # BUILD/spring/lib/tomcat/naming-resources.jar.no



--- spring2.spec~	2012-03-20 23:43:25.000000000 +0000
+++ spring2.spec	2012-06-01 19:38:13.851010907 +0000
@@ -1158,7 +1158,7 @@
 ln -sf $(build-classpath struts-tiles) lib/struts/struts-tiles.jar
 ln -sf $(build-classpath struts-extras) lib/struts/struts-extras.jar
 # BUILD/spring/lib/testng/testng-5.8-jdk15.jar.no
-ln -sf $(build-classpath testng-jdk15) lib/testng/testng-5.8-jdk15.jar
+ln -sf $(build-classpath testng) lib/testng/testng-5.8-jdk15.jar
 ln -sf $(build-classpath jcommander) lib/testng/jcommander.jar
 ln -sf $(build-classpath objenesis) lib/testng/objenesis.jar
 # BUILD/spring/lib/tiles/tiles-api-2.0.6.jar.no

--- spring2.spec~       2012-06-22 18:29:51.000000000 +0300
+++ spring2.spec        2012-06-22 18:31:54.000000000 +0300
@@ -1104,7 +1104,7 @@
 # BUILD/spring/lib/jets3t/jets3t.jar.no
 ln -sf $(build-classpath jets3t/jets3t) lib/jdt/jdt-compiler-3.1.1.jar
 # BUILD/spring/lib/jexcelapi/jxl.jar.no
-ln -sf $(build-classpath jexcelapi) lib/jexcelapi/jxl.jar
+ln -sf $(build-classpath jexcelapi/jxl) lib/jexcelapi/jxl.jar
 # BUILD/spring/lib/jmock/jmock-cglib.jar.no
 ln -sf $(build-classpath jmock-cglib) lib/jmock/jmock-cglib.jar
 # BUILD/spring/lib/jmock/jmock.jar.no
