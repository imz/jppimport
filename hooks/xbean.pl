#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # Was:# -Dmaven.test.skip=true

    $jpp->get_section('package','')->unshift_body('BuildRequires: spring2-beans spring2-context spring2-web'."\n");

    $jpp->source_apply_patch(SOURCEFILE=>'pom-3.8.patch', PATCHSTRING=>q!
--- pom-3.7.patch.orig	2011-05-30 12:20:07.000000000 +0300
+++ pom-3.7.patch	2012-05-08 19:21:32.000000000 +0300
@@ -14,42 +14,6 @@
      <groupId>org.apache.xbean</groupId>
      <artifactId>xbean</artifactId>
      <name>Apache XBean</name>
-@@ -265,33 +259,15 @@
-             </dependency>
- 
-             <dependency>
--                <groupId>org.springframework</groupId>
--                <artifactId>spring-beans</artifactId>
--                <version>2.5.6</version>
--            </dependency>
--
--            <dependency>
--                <groupId>org.springframework</groupId>
--                <artifactId>spring-context</artifactId>
--                <version>2.5.6</version>
--            </dependency>
--
--            <dependency>
--                <groupId>org.springframework</groupId>
--                <artifactId>spring-web</artifactId>
--                <version>2.5.6</version>
--            </dependency>
--
--            <dependency>
-                 <groupId>com.thoughtworks.qdox</groupId>
-                 <artifactId>qdox</artifactId>
-                 <version>1.6.3</version>
-             </dependency>
--            
-+
-             <dependency>
-                 <groupId>org.slf4j</groupId>
-                 <artifactId>slf4j-api</artifactId>
--                <version>1.5.11</version>                
-+                <version>1.5.11</version>
-             </dependency>
-         </dependencies>
-     </dependencyManagement>
 @@ -327,13 +303,13 @@
                      <artifactId>maven-bundle-plugin</artifactId>
                      <version>2.0.0</version>
@@ -71,7 +35,7 @@
                  </plugin>
              </plugins>
          </pluginManagement>
-@@ -343,22 +319,22 @@
+@@ -343,22 +319,24 @@
                  <groupId>org.apache.felix</groupId>
                  <artifactId>maven-bundle-plugin</artifactId>
              </plugin>
@@ -93,9 +57,9 @@
          <module>xbean-naming</module>
          <module>xbean-reflect</module>
 -        <module>xbean-blueprint</module>
--        <module>xbean-spring</module>
+         <module>xbean-spring</module>
 -        <module>xbean-telnet</module>
--        <module>maven-xbean-plugin</module>
+         <module>maven-xbean-plugin</module>
 -        <module>xbean-asm-shaded</module>
 -        <module>xbean-finder-shaded</module>
      </modules>
!);

    $jpp->spec_apply_patch(PATCHSTRING=>q!
--- xbean.spec	2012-05-08 17:36:49.039585620 +0000
+++ xbean.spec	2012-05-08 17:39:51.606939971 +0000
@@ -87,7 +88,7 @@
 
 %install
 # for every module we want to be built
-for sub in bundleutils finder reflect naming classpath; do
+for sub in bundleutils finder reflect naming classpath spring; do
     # install jar
     install -Dpm 644 %{name}-${sub}/target/%{name}-${sub}-%{version}.jar \
             $RPM_BUILD_ROOT/%{_javadir}/xbean/%{name}-${sub}.jar;
@@ -99,6 +100,18 @@
     %add_to_maven_depmap org.apache.xbean %{name}-${sub} %{version} JPP/%{name} %{name}-${sub}
 done
 
+
+    # install jar
+    install -Dpm 644 maven-xbean-plugin/target/maven-xbean-plugin-%{version}.jar \
+            $RPM_BUILD_ROOT/%{_javadir}/xbean/maven-xbean-plugin.jar;
+
+    # intall pom
+    install -Dpm 644 maven-xbean-plugin/pom.xml $RPM_BUILD_ROOT/%{_mavenpomdir}/JPP.%{name}-maven-xbean-plugin.pom
+
+    # maven depmap
+    %add_to_maven_depmap org.apache.xbean maven-xbean-plugin %{version} JPP/%{name} maven-xbean-plugin
+
+
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}
 cp -pr target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}
 
!);


};

__END__
