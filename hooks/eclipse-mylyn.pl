#!/usr/bin/perl -w
push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # not required (see below -sf)
    # $jpp->get_section('install')->subst('^rm \*\.jar\s*$','rm -f *.jar'."\n");
    #$jpp->get_section('install')->subst_if(qr'ln -s ','ln -sf ', qr'(jdom-1.0.jar|commons-lang.jar)');

    $jpp->get_section('prep')->subst(qr'ws-commons-util-1.0.1.jar','ws-commons-util.jar');
    
};

#java -cp /usr/src/RPM/BUILD/org.eclipse.mylyn/SDK/startup.jar -Dosgi.sharedConfiguration.area=/usr/lib64/eclipse/configuration org.eclipse.core.launcher.Main -application org.eclipse.ant.core.antRunner -DjavacSource=1.5 -DjavacTarget=1.5 -Dtype=feature -Did=org.eclipse.mylyn.pde_feature -DbaseLocation=/usr/src/RPM/BUILD/org.eclipse.mylyn/SDK -DsourceDirectory=/usr/src/RPM/BUILD/org.eclipse.mylyn -DbuildDirectory=/usr/src/RPM/BUILD/org.eclipse.mylyn/build -Dbuilder=/usr/share/eclipse/plugins/org.eclipse.pde.build/templates/package-build -f /usr/share/eclipse/plugins/org.eclipse.pde.build/scripts/build.xml -vmargs -Duser.home=/usr/src/RPM/BUILD/org.eclipse.mylyn/home -DJ2SE-1.5=/usr/lib/jvm/java/jre/lib/rt.jar
