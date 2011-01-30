#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-surefire-provider-junit4 jakarta-commons-net14\n");
    # test fails :(
    $jpp->get_section('package','')->unshift_body("BuildRequires: jakarta-commons-net14\n");
    # for build-classpath nlog4j
    $jpp->get_section('package','')->unshift_body("BuildRequires: nlog4j\n");
    $jpp->get_section('package','core')->subst_if('jakarta-commons-collections32','jakarta-commons-collections',qr'Requires:');

    $jpp->applied_block(
	"var lib",
	sub {
	    foreach my $section ($jpp->get_sections()) {
		my $t=$section->get_type();
		if ($t eq 'install' or $t eq 'files') {
		    $section->subst(qr'%{_var}/%{name}','%{_var}/lib/%{name}');
		}
	    }
	}
	);
};

__END__
#1.0.2
SOURCES:
--- apacheds-jpp-depmap.xml.orig        2009-02-11 20:57:27 +0000
+++ apacheds-jpp-depmap.xml     2009-02-11 20:58:54 +0000
@@ -30,9 +30,9 @@
          <version>2.0.1</version>
       </maven>
       <jpp>
-         <groupId>JPP/maven2</groupId>
+         <groupId>JPP/maven-shared</groupId>
          <artifactId>archiver</artifactId>
-         <version>2.0.1</version>
+         <version>2.1</version>
       </jpp>
    </dependency>
    <dependency>
@@ -35,7 +35,7 @@
       </maven>
       <jpp>
          <groupId>JPP</groupId>
-         <artifactId>commons-collections32</artifactId>
+         <artifactId>commons-collections</artifactId>
          <version>3.2</version>
       </jpp>
    </dependency>
