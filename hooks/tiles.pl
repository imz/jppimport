push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: xpp3\n");
};
__END__
# 208 hacks
mkdir -p $MAVEN_REPO_LOCAL/org/apache/tiles/tiles-master/1/
cp %{SOURCE5} .m2/repository/org/apache/tiles/tiles-master/1/tiles-master-1.pom
mkdir -p $MAVEN_REPO_LOCAL/org/apache/tiles/tiles-{api,core,jsp}/%{version}/
ln -sf ../org/apache/tiles/tiles-api/%{version}/tiles-api-%{version}.jar $MAVEN_REPO_LOCAL/org/apache/tiles/tiles-api/%{version}/
ln -sf ../org/apache/tiles/tiles-core/%{version}/tiles-core-%{version}.jar $MAVEN_REPO_LOCAL/org/apache/tiles/tiles-core/%{version}/
ln -sf ../org/apache/tiles/tiles-jsp/%{version}/tiles-jsp-%{version}.jar $MAVEN_REPO_LOCAL/org/apache/tiles/tiles-jsp/%{version}/
# end 208 hacks
--- tiles.spec	2009-02-13 15:08:04 +0000
+++ tiles.spec	2009-02-13 15:14:59 +0000
@@ -163,6 +164,14 @@
     mvn-jpp \
         -e \
         -s $M2_SETTINGS \
+        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
+        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
+      install:install-file -DgroupId=xpp3 -DartifactId=xpp3_min \
+                -Dversion=1.1.4c -Dpackaging=jar -Dfile=$(build-classpath xpp3)
+
+    mvn-jpp \
+        -e \
+        -s $M2_SETTINGS \
         -Dmaven.test.failure.ignore=true \
         -Dmaven2.jpp.depmap.file=%{SOURCE2} \
         -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
