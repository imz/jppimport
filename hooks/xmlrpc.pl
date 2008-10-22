#require 'set_target_14.pl';
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # todo: disable tests! Out of memory!
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-scm maven2-default-skin\n");
};

__END__
# info: hacks for xmlrpc3:
--- xmlrpc3.spec.0      2008-10-21 15:21:46 +0000
+++ xmlrpc3.spec        2008-10-21 14:21:52 +0000
@@ -173,11 +173,16 @@
 mkdir -p $MAVEN_REPO_LOCAL
 # The java.home is due to java-gcj and libgcj weirdness on 64-bit
 # systems
+
+# hack due to test skip
+%__subst 's,<module>tests</module>,<!--<module>tests</module>-->,' pom.xml
+
 mvn-jpp \
   -e \
   -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
   -Djava.home=%{_jvmdir}/java/jre \
   -Dmaven2.jpp.depmap.file=%{SOURCE1} \
+  -Dmaven.test.skip=true \
   -Dmaven.test.failure.ignore=true \
   install javadoc:javadoc
 
