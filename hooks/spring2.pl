#!/usr/bin/perl -w

require 'windows-thumbnail-database-in-package.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
# do we need it? inherited, but not tested
    $jpp->get_section('package','')->unshift_body('BuildRequires: avalon-framework'."\n");
};
__END__
current - fixes for old slf4j and old tiles

--- spring2.spec.0	2012-01-20 17:53:05.042587824 +0000
+++ spring2.spec	2012-01-20 19:07:39.150562692 +0000
@@ -1149,9 +1149,9 @@
 # BUILD/spring/lib/serp/serp-1.13.1.jar.no
 ln -sf $(build-classpath serp) lib/serp/serp-1.13.1.jar
 # BUILD/spring/lib/slf4j/slf4j-api-1.5.0.jar.no
-ln -sf $(build-classpath slf4j/slf4j-api) lib/slf4j/slf4j-api-1.5.0.jar
+ln -sf $(build-classpath slf4j/api) lib/slf4j/slf4j-api-1.5.0.jar
 # BUILD/spring/lib/slf4j/slf4j-log4j12-1.5.0.jar.no
-ln -sf $(build-classpath slf4j/slf4j-log4j12) lib/slf4j/slf4j-log4j12-1.5.0.jar
+ln -sf $(build-classpath slf4j/log4j12) lib/slf4j/slf4j-log4j12-1.5.0.jar
 # BUILD/spring/lib/struts/struts.jar.no
 ln -sf $(build-classpath struts) lib/struts/struts.jar
 ln -sf $(build-classpath struts-tiles) lib/struts/struts-tiles.jar
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



___OOOOLD_HACKS__
hack; see
http://jira.springframework.org/browse/SPR-5145
ALSO
http://jira.springframework.org/secure/attachment/14674/junit4.5.patch
986c986,987
< ln -sf $(build-classpath junit4) lib/junit/junit-4.4.jar
---
> #ln -sf $(build-classpath junit4) lib/junit/junit-4.4.jar
> mv lib/junit/junit-4.4.jar.no lib/junit/junit-4.4.jar

# slf4j 1.6
1136c1136
< ln -sf $(build-classpath slf4j/api) lib/slf4j/slf4j-api-1.5.0.jar
---
> ln -sf $(build-classpath slf4j/slf4j-api) lib/slf4j/slf4j-api-1.5.0.jar
1138c1138
< ln -sf $(build-classpath slf4j/log4j12) lib/slf4j/slf4j-log4j12-1.5.0.jar
---
> ln -sf $(build-classpath slf4j/slf4j-log4j12) lib/slf4j/slf4j-log4j12-1.5.0.jar

