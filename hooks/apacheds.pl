#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-surefire-provider-junit4\n");
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
    #$jpp->get_section('package','')->unshift_body("BuildRequires: maven-surefire-plugin mojo-maven2-plugin-antlr maven2-plugin-plugin maven2-plugins maven-shared-archiver\n");

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
