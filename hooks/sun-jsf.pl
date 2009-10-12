#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jetty6-core'."\n");
    $jpp->add_patch('sun-jsf-alt-add-jetty6.patch');
    $jpp->add_patch('sun-jsf-1.2.04-alt-fix-build-with-jetty6.1.14.patch');
}

1;
__END__
@@ -162,6 +167,8 @@
 ln -sf $(build-classpath jetty6/annotations/jetty6-annotations) dependencies/jetty-6.1.2rc0/lib/annotations/jetty-annotations-6.1.2rc0.jar
 mkdir -p dependencies/jetty-6.1.2rc0/lib/plus
 ln -sf $(build-classpath jetty6/plus/jetty6-plus) dependencies/jetty-6.1.2rc0/lib/plus/jetty-plus-6.1.2rc0.jar
+ln -sf $(build-classpath jetty6/core/jetty6) dependencies/jetty-6.1.2rc0/lib/jetty6.jar
+ln -sf $(build-classpath jetty6/core/jetty6-util) dependencies/jetty-6.1.2rc0/lib/jetty6-util.jar

 # TODO: bring in glassfish-appserv-rt.jar dependency
 #mkdir -p dependencies/glassfish/lib/
