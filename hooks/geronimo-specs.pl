#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
my @obsolete=qw/
geronimo-corba-3.0-apis			geronimo-specs-corba
geronimo-ejb-2.1-api			geronimo-specs-ejb
geronimo-j2ee-connector-1.5-api		geronimo-specs-j2ee-connector
geronimo-j2ee-deployment-1.1-api	geronimo-specs-j2ee-deployment
geronimo-j2ee-management-1.0-api	geronimo-specs-j2ee-management
geronimo-jacc-1.0-api			geronimo-specs-j2ee-jacc
geronimo-jaf-1.0.2-api			geronimo-specs-activation
geronimo-javamail-1.3.1-api		geronimo-specs-javamail
geronimo-jaxr-1.0-api			geronimo-specs-jaxr
geronimo-jaxrpc-1.1-api			geronimo-specs-jaxrpc
geronimo-jms-1.1-api			geronimo-specs-jms
geronimo-jsp-2.0-api			geronimo-specs-jsp
geronimo-jta-1.0.1B-api			geronimo-specs-jta
geronimo-qname-1.1-api			geronimo-specs-qname
geronimo-saaj-1.1-api			geronimo-specs-saaj
geronimo-servlet-2.4-api		geronimo-specs-servlet
/;
    while (scalar @obsolete) {
	my $new = shift @obsolete;
	my $old = shift @obsolete;
	$jpp->get_section('package','-n '.$new)->push_body('Obsoletes: '.$old.' < 1.1'."\n");
#	$jpp->get_section('package','-n '.$new)->push_body('Provides: '.$old.' = 1.1'."\n");
    }

    # maven2-208-29+jpp5
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-site'."\n");

}
__END__
# TODO:
j2ee-api does not have jms alternative (see hack around spring)

# patch: 1) remove provides as they are doubtful.
# 2) fix versions properly: bug in jpackage 5.0; TODO: report
--- geronimo-specs.spec	2009-08-22 16:36:59 +0300
+++ geronimo-specs.spec	2009-08-22 16:35:15 +0300
@@ -436,14 +436,16 @@
 # XXX: (dwalluck): section added for backwards compatibility with Fedora 9
 #
 # Provides:  commonj = 0:1.1
-Provides:    ejb = 0:2.1
+### should also provide ejb.jar!
+###Provides:    ejb = 0:2.1
 # Provides:  corba = 0:2.3
 Provides:    j2ee-connector = 0:1.5
 Provides:    j2ee-deployment = 0:1.1
 Provides:    j2ee-management = 0:1.0
 Provides:    jacc = 0:1.0
-Provides:    jaf = 0:1.0.2
-Provides:    javamail = 0:1.3.1
+### should also provide javamail.jar!
+###Provides:    jaf = 0:1.0.2
+###Provides:    javamail = 0:1.3.1
 Provides:    jaxr = 0:1.0
 Provides:    jaxrpc = 0:1.1
 Provides:    jms = 0:1.1
@@ -1429,84 +1431,84 @@
 # main package jars
 install -d -m 0755 $RPM_BUILD_ROOT%{_javadir}/geronimo
 pushd $RPM_BUILD_ROOT%{_javadir}/geronimo
-  ln -sf ../geronimo-commonj-1.1-apis-%{version}.jar spec-commonj-1.1-%{version}.jar
+  ln -sf ../geronimo-commonj-1.1-apis-1.0.jar spec-commonj-1.1-%{version}.jar
   ln -sf spec-commonj-1.1-%{version}.jar spec-commonj-1.1.jar
 
   ln -sf ../geronimo-jaf-1.0.2-api-%{version}.jar spec-jaf-1.0.2-%{version}.jar
   ln -sf spec-jaf-1.0.2-%{version}.jar spec-jaf-1.0.2.jar
 
-  ln -sf ../geronimo-jaf-1.1-api-%{version}.jar spec-jaf-1.1-%{version}.jar
+  ln -sf ../geronimo-jaf-1.1-api-1.0.jar spec-jaf-1.1-%{version}.jar
   ln -sf spec-jaf-1.1-%{version}.jar spec-jaf-1.1.jar
 
-  ln -sf ../geronimo-annotation-1.0-api-%{version}.jar spec-annotation-1.0-%{version}.jar
+  ln -sf ../geronimo-annotation-1.0-api-1.1.0.jar spec-annotation-1.0-%{version}.jar
   ln -sf spec-annotation-1.0-%{version}.jar spec-annotation-1.0.jar
 
-  ln -sf ../geronimo-ejb-2.1-api-%{version}.jar spec-ejb-2.1-%{version}.jar
+  ln -sf ../geronimo-ejb-2.1-api-1.1.jar spec-ejb-2.1-%{version}.jar
   ln -sf spec-ejb-2.1-%{version}.jar spec-ejb-2.1.jar
 
-  ln -sf ../geronimo-ejb-3.0-api-%{version}.jar spec-ejb-3.0-%{version}.jar
+  ln -sf ../geronimo-ejb-3.0-api-1.0.jar spec-ejb-3.0-%{version}.jar
   ln -sf spec-ejb-3.0-%{version}.jar spec-ejb-3.0.jar
 
-  ln -sf ../geronimo-el-1.0-api-%{version}.jar spec-el-1.0-%{version}.jar
+  ln -sf ../geronimo-el-1.0-api-1.0.jar spec-el-1.0-%{version}.jar
   ln -sf spec-el-1.0-%{version}.jar spec-el-1.0.jar
 
-  ln -sf ../geronimo-interceptor-3.0-api-%{version}.jar spec-interceptor-3.0-%{version}.jar
+  ln -sf ../geronimo-interceptor-3.0-api-1.0.jar spec-interceptor-3.0-%{version}.jar
   ln -sf spec-interceptor-3.0-%{version}.jar spec-interceptor-3.0.jar
 
-  ln -sf ../geronimo-j2ee-connector-1.5-api-%{version}.jar \
+  ln -sf ../geronimo-j2ee-connector-1.5-api-1.1.1.jar \
     spec-j2ee-connector-1.5-%{version}.jar
   ln -sf spec-j2ee-connector-1.5-%{version}.jar spec-j2ee-connector-1.5.jar
 
-  ln -sf ../geronimo-j2ee-deployment-1.1-api-%{version}.jar \
+  ln -sf ../geronimo-j2ee-deployment-1.1-api-1.1.jar \
     spec-j2ee-deployment-1.1-%{version}.jar
   ln -sf spec-j2ee-deployment-1.1-%{version}.jar spec-j2ee-deployment-1.1.jar
 
-  ln -sf ../geronimo-javaee-deployment-1.1-api-%{version}.jar \
+  ln -sf ../geronimo-javaee-deployment-1.1-api-1.0.jar \
     spec-javaee-deployment-1.1-%{version}.jar
   ln -sf spec-javaee-deployment-1.1-%{version}.jar spec-javaee-deployment-1.1.jar
 
-  ln -sf ../geronimo-jacc-1.0-api-%{version}.jar spec-jacc-1.0-%{version}.jar
+  ln -sf ../geronimo-jacc-1.0-api-1.1.jar spec-jacc-1.0-%{version}.jar
   ln -sf spec-jacc-1.0-%{version}.jar spec-jacc-1.0.jar
 
-  ln -sf ../geronimo-jacc-1.1-api-%{version}.jar spec-jacc-1.1-%{version}.jar
+  ln -sf ../geronimo-jacc-1.1-api-1.0.jar spec-jacc-1.1-%{version}.jar
   ln -sf spec-jacc-1.1-%{version}.jar spec-jacc-1.1.jar
 
-  ln -sf ../geronimo-j2ee-management-1.0-api-%{version}.jar \
+  ln -sf ../geronimo-j2ee-management-1.0-api-1.1.jar \
     spec-j2ee-management-1.0-%{version}.jar
   ln -sf spec-j2ee-management-1.0-%{version}.jar spec-j2ee-management-1.0.jar
 
-  ln -sf ../geronimo-j2ee-management-1.1-api-%{version}.jar \
+  ln -sf ../geronimo-j2ee-management-1.1-api-1.0.jar \
     spec-j2ee-management-1.1-%{version}.jar
   ln -sf spec-j2ee-management-1.1-%{version}.jar spec-j2ee-management-1.1.jar
 
   ln -sf ../geronimo-j2ee-1.4-apis-%{version}.jar spec-j2ee-1.4-%{version}.jar
   ln -sf spec-j2ee-1.4-%{version}.jar spec-j2ee-1.4.jar
 
-  ln -sf ../geronimo-jms-1.1-api-%{version}.jar spec-jms-1.1-%{version}.jar
+  ln -sf ../geronimo-jms-1.1-api-1.1.jar spec-jms-1.1-%{version}.jar
   ln -sf spec-jms-1.1-%{version}.jar spec-jms-1.1.jar
 
-  ln -sf ../geronimo-jpa-3.0-api-%{version}.jar spec-jpa-3.0-%{version}.jar
+  ln -sf ../geronimo-jpa-3.0-api-1.1.0.jar spec-jpa-3.0-%{version}.jar
   ln -sf spec-jpa-3.0-%{version}.jar spec-jpa-3.0.jar
 
-  ln -sf ../geronimo-jsp-2.0-api-%{version}.jar spec-jsp-2.0-%{version}.jar
+  ln -sf ../geronimo-jsp-2.0-api-1.1.jar spec-jsp-2.0-%{version}.jar
   ln -sf spec-jsp-2.0-%{version}.jar spec-jsp-2.0.jar
 
-  ln -sf ../geronimo-jsp-2.1-api-%{version}.jar spec-jsp-2.1-%{version}.jar
+  ln -sf ../geronimo-jsp-2.1-api-1.0.jar spec-jsp-2.1-%{version}.jar
   ln -sf spec-jsp-2.1-%{version}.jar spec-jsp-2.1.jar
 
-  ln -sf ../geronimo-jta-1.0.1B-api-%{version}.jar spec-jta-1.0.1B-%{version}.jar
+  ln -sf ../geronimo-jta-1.0.1B-api-1.1.1.jar spec-jta-1.0.1B-%{version}.jar
   ln -sf spec-jta-1.0.1B-%{version}.jar spec-jta-1.0.1B.jar
 
-  ln -sf ../geronimo-jta-1.1-api-%{version}.jar spec-jta-1.1-%{version}.jar
+  ln -sf ../geronimo-jta-1.1-api-1.1.0.jar spec-jta-1.1-%{version}.jar
   ln -sf spec-jta-1.1-%{version}.jar spec-jta-1.1.jar
 
-  ln -sf ../geronimo-servlet-2.4-api-%{version}.jar spec-servlet-2.4-%{version}.jar
+  ln -sf ../geronimo-servlet-2.4-api-1.1.1.jar spec-servlet-2.4-%{version}.jar
   ln -sf spec-servlet-2.4-%{version}.jar spec-servlet-2.4.jar
-  ln -sf ../geronimo-servlet-2.5-api-%{version}.jar spec-servlet-2.5-%{version}.jar
+  ln -sf ../geronimo-servlet-2.5-api-1.1.jar spec-servlet-2.5-%{version}.jar
   ln -sf spec-servlet-2.5-%{version}.jar spec-servlet-2.5.jar
-  ln -sf ../geronimo-stax-1.0-api-%{version}.jar spec-stax-1.0-%{version}.jar
+  ln -sf ../geronimo-stax-1.0-api-1.0.jar spec-stax-1.0-%{version}.jar
   ln -sf spec-stax-1.0-%{version}.jar spec-stax-1.0.jar
-  ln -sf ../geronimo-ws-metadata-2.0-api-%{version}.jar spec-ws-metadata-2.0-%{version}.jar
+  ln -sf ../geronimo-ws-metadata-2.0-api-1.1.1.jar spec-ws-metadata-2.0-%{version}.jar
   ln -sf spec-ws-metadata-2.0-%{version}.jar spec-ws-metadata-2.0.jar
 popd
 
