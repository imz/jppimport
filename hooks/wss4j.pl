push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # alt prehistory ? :(
    $jpp->get_section('package','')->subst(qr'BuildRequires: java-1.5.0-sun-jce-policy','#BuildRequires: java-1.5.0-sun-jce-policy');
}



__END__
# 1.7
--- wss4j.spec.old	2008-01-26 21:37:14 +0300
+++ wss4j.spec	2008-01-26 21:45:34 +0300
@@ -1,3 +1,4 @@
+BuildRequires: bouncycastle-jdk1.4
 BuildRequires: /proc
 BuildRequires: jpackage-1.4-compat
 # Copyright (c) 2000-2007, JPackage Project
@@ -120,7 +121,7 @@
       axis/axis-ant \
       axis/jaxrpc \
       axis/saaj \
-      bouncycastle/bcprov \
+      \
       jaf \
       jakarta-commons-codec \
       jakarta-commons-discovery \
@@ -135,7 +136,9 @@
       wsdl4j \
       xalan-j2 \
       xml-security
-
+pushd lib
+ln -s /usr/share/java-ext/bouncycastle-jdk1.4/bcprov.jar .
+popd
 
 mkdir -p target/work/org/apache/ws/axis/oasis/ping
 
