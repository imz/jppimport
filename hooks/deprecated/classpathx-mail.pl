#!/usr/bin/perl -w

# target_14
require 'set_sasl_hook.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body('# required for fedora tomcat
Provides: javamail = 0:1.3.1
Provides: javamail-monolithic = 0:1.3.1
');
    $spec->get_section('package','')->subst(qr'BuildRequires:\s*classpathx-jaf','#BuildRequires: classpathx-jaf');
}
__END__
--- classpathx-mail.spec.0      2010-10-23 13:44:46.098206697 +0000
+++ classpathx-mail.spec        2010-10-23 13:45:10.306237539 +0000
@@ -117,6 +117,7 @@
 # build mail
 export CLASSPATH=%(build-classpath jaf_1_1_api)
 ant -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5 \
+        -Dactivation.available=true \
   -Dj2se.apidoc=%{_javadocdir}/java \
   -Djaf.apidoc=%{_javadocdir}/jaf \
   dist javadoc
