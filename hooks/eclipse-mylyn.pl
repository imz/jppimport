#!/usr/bin/perl -w
#require 'set_fix_eclipse_dep.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # due to old splitting...
    $jpp->get_section('package','')->unshift_body('BuildRequires: lucene1-demo jetty5 tomcat5-jasper'."\n");
    $jpp->get_section('install')->subst('^rm \*\.jar\s*$','rm -f *.jar'."\n");

};

#java -cp /usr/src/RPM/BUILD/org.eclipse.mylyn/SDK/startup.jar -Dosgi.sharedConfiguration.area=/usr/lib64/eclipse/configuration org.eclipse.core.launcher.Main -application org.eclipse.ant.core.antRunner -DjavacSource=1.5 -DjavacTarget=1.5 -Dtype=feature -Did=org.eclipse.mylyn.pde_feature -DbaseLocation=/usr/src/RPM/BUILD/org.eclipse.mylyn/SDK -DsourceDirectory=/usr/src/RPM/BUILD/org.eclipse.mylyn -DbuildDirectory=/usr/src/RPM/BUILD/org.eclipse.mylyn/build -Dbuilder=/usr/share/eclipse/plugins/org.eclipse.pde.build/templates/package-build -f /usr/share/eclipse/plugins/org.eclipse.pde.build/scripts/build.xml -vmargs -Duser.home=/usr/src/RPM/BUILD/org.eclipse.mylyn/home -DJ2SE-1.5=/usr/lib/jvm/java/jre/lib/rt.jar
