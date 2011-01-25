#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('#define _without_bootstrap 1'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: maven-shared-archiver plexus-containers-container-default plexus-containers plexus-classworlds maven-plugin-tools plexus-cli plexus-containers-component-annotations 
BuildRequires: maven-enforcer maven2-plugin-war geronimo-j2ee-1.4-apis
# unbootstrap
BuildRequires: maven2-plugin-ant
BuildRequires: maven2-plugin-assembly
BuildRequires: maven2-plugin-clean
BuildRequires: maven2-plugin-compiler
BuildRequires: maven2-plugin-install
BuildRequires: maven2-plugin-jar
BuildRequires: maven2-plugin-javadoc
BuildRequires: maven2-plugin-plugin
BuildRequires: maven2-plugin-resources
BuildRequires: maven2-plugin-shade
BuildRequires: maven2-plugin-site
BuildRequires: maven-surefire-plugin
BuildRequires: maven-shared-archiver
BuildRequires: maven-doxia-sitetools
BuildRequires: maven-embedder
BuildRequires: maven-scm >= 0:1.0-0.b3.2         
BuildRequires: maven-scm-test >= 0:1.0-0.b3.2    
BuildRequires: maven-shared-common-artifact-filters         
BuildRequires: maven-shared-dependency-analyzer  
BuildRequires: maven-shared-dependency-tree      
BuildRequires: maven-shared-downloader
BuildRequires: maven-shared-file-management >= 1.0          
BuildRequires: maven-shared-io        
BuildRequires: maven-shared-plugin-testing-harness >= 1.0   
BuildRequires: maven-shared-repository-builder   
BuildRequires: maven-shared-invoker   
BuildRequires: maven-shared-jar       
BuildRequires: maven-shared-model-converter      
BuildRequires: maven-shared-plugin-testing-tools 
BuildRequires: maven-shared-plugin-tools-api     
BuildRequires: maven-shared-plugin-tools-beanshell          
BuildRequires: maven-shared-plugin-tools-java    
BuildRequires: maven-shared-reporting-impl       
BuildRequires: maven-shared-verifier  
BuildRequires: maven-surefire >= 2.0  
BuildRequires: maven-surefire-provider-junit     
BuildRequires: maven-surefire-booter >= 2.0      
BuildRequires: modello >= 1.0-0.a8.3  
BuildRequires: maven-plugin-modello >= 1.0-0.a8.3
BuildRequires: plexus-digest
BuildRequires: plexus-maven-plugin >= 1.3.5
BuildRequires: plexus-mail-sender
BuildRequires: plexus-resources
'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: jakarta-commons-digester jakarta-commons-parent excalibur-avalon-framework'."\n");

    # it might break jpp patch and jpp local repository, so apply later; or remove;
    #$jpp->add_patch('maven-2.0.x-MNG-3948.patch', STRIP=>1);

    # instead try out revisions between 358877(MSITE-59 applied) and 591652(after strange revolution, bug might be fixed)
    # also, the probability is the bug is related to plexus-cdc incompatibility
    # TODO: and update patches
    #$jpp->add_patch('maven-plugin-site-MSITE-59.patch', STRIP=>0);

    # maven2-plugin-javadoc reqs avalon-framework pom due to pom dependencies
    $jpp->get_section('package','plugin-javadoc')->push_body('Requires: excalibur-avalon-framework'."\n");
    # NO NEED: already in 6.0 common poms
    #$jpp->get_section('package','plugin-javadoc')->push_body('Requires: excalibur'."\n");

    unless ('revert to a7') {
	# I do not want to update(revert) plexus-archiver from a8 to a7.
	# so disable maven2-plugins-catch-uncaught-exceptions.patch
	$jpp->get_section('prep')->subst(qr'^\%patch4\s','#patch4 ');
	# and make other similar patches
	$jpp->add_patch('maven2-2.0.8-alt-plexus-archiver-a8.patch',STRIP=>1);
    }

    # tmp hack over sandbox error :(
    #$jpp->get_section('package','')->push_body('ExclusiveArch: x86_64'."\n");
    $jpp->add_patch('maven2-2.0.8-alt-bootstrap-fix-descriptor-leak.patch',STRIP=>0);

    $jpp->get_section('prep')->push_body(q~
cat > relink_bootstrap_maven_jars.sh << 'EOF'
#!/bin/sh
DUP='cp -pL'
pushd m2_repo/repository/JPP
for i in `find m* plexus/[adr-x]* plexus/mail* plexus/c[ol]*  -type f -name '*.jar'`;do
    if [ -f /usr/share/java/$i ]; then
    mv $i $i.no;
    $DUP /usr/share/java/$i $i
    fi
done
i=maven-archiver.jar; mv $i $i.no; $DUP /usr/share/java/maven-shared/archiver.jar $i
i=maven-embedder.jar; mv $i $i.no; $DUP /usr/share/java/maven2/embedder.jar $i
i=maven-enforcer-rule-api.jar; mv $i $i.no; $DUP /usr/share/java/maven-enforcer/enforcer-api.jar $i
# TODO
#i=maven2-plugin-cobertura.jar; mv $i $i.no; $DUP  $i
i=maven-shared/maven-plugin-testing-harness.jar; mv $i $i.no; $DUP /usr/share/java/maven-shared/plugin-testing-harness.jar $i
i=maven-reporting/impl.jar; mv $i $i.no; $DUP maven-shared/reporting-impl.jar $i
find . -name '*.jar.no' -delete
popd
EOF
#%_sourcedir
sh ./relink_bootstrap_maven_jars.sh
~."\n");

    # we hack bootsrap repo at code above; tar xzf overwrites our hacks :(
    $jpp->get_section('install')->unshift_body_after('sh ./relink_bootstrap_maven_jars.sh'."\n", qr'tar xzf \%{SOURCE4}');
};

__END__
__DATA__
#2) some plexuses are missing components.xml (which ones?)
are good
m* plexus/[adr-x]* plexus/mail* plexus/c[ol]* 
# suspects:
# criminal: plexus/cdc.jar
Embedded error: Error reading input descriptor for merge: /usr/src/RPM/BUILD/maven2/maven2-plugins/maven-assembly-plugin/target/generated-resources/plexus/META-INF/plexus/components.xml
/usr/src/RPM/BUILD/maven2/maven2-plugins/maven-assembly-plugin/target/generated-resources/plexus/META-INF/plexus/components.xml (No such file or directory)
# criminal: plexus/maven-plugin.jar
Embedded error: Error reading input descriptor for merge: /usr/src/RPM/BUILD/maven2/maven2-plugins/maven-assembly-plugin/target/generated-resources/plexus/META-INF/plexus/components.xml
...
        at org.codehaus.plexus.cdc.DefaultComponentDescriptorCreator.mergeDescriptors(DefaultComponentDescriptorCreator.java:246)

plexus: seems there is a need for downgrade,
or, at least, to simplify their components (let us try on cdc)

relink_bootstrap_maven_jars.sh
#!/bin/sh
pushd m2_repo/repository/JPP
for i in `find m* plexus/[adr-x]* plexus/mail* plexus/c[ol]*  -type f -name '*.jar'`;do
    if [ -f /usr/share/java/$i ]; then
    mv $i $i.no;
    ln /usr/share/java/$i $i
    fi
done
popd
