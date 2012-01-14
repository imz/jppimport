#!/usr/bin/perl -w

sub _add_jar {
    my ($jpp, $exe) = @_;
    #$jpp->get_section('build')->unshift_body_after(qr'^export SETTINGS=',q!
    $jpp->get_section('build')->unshift_body_after(qr'^\%endif',q!
mvn-jpp -e \
    -s ${SETTINGS} \
    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
    -Dmaven.test.failure.ignore=true \
    -Dmaven2.jpp.depmap.file=%{SOURCE2} \
    !.$exe."\n");
}

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','-n mojo-maven2-plugin-antlr')->push_body('Provides: maven2-plugin-antlr = 2.0.4'."\n");

    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-jpa-3.0-api javacc3'."\n");

    $jpp->add_patch('mojo-maven2-plugins-17-alt-maven-wagon-a7-support.patch', STRIP=>0);#, NUMBER=>233);
    
    $_="# hack: use old modello10 instead of providing model for new modello, see messages
[INFO] One or more required plugin parameters are invalid/missing for 'modello:java'
[0] Inside the definition for plugin 'modello-maven-plugin' specify the following:
<configuration>
  ...
  <models>VALUE</models>
</configuration>.
    ";
	$jpp->applied_block(
	"use old modello10 hook",
	sub {
	    foreach my $sec ($jpp->get_sections) {
		next if $sec->get_type ne 'package';
		$sec->subst_if(qr'modello','modello10','^BuildRequires:');
		$sec->subst_if(qr'modello-maven-plugin','modello10','^BuildRequires:');
	    }
	}
	);

    &_add_jar($jpp, 'install:install-file -DgroupId=easymock -DartifactId=easymock -Dversion=1.1 -Dpackaging=jar -Dfile=$(build-classpath easymock)');
    &_add_jar($jpp, 'install:install-file -DgroupId=org.eclipse.jdt.core.compiler -DartifactId=ecj -Dversion=3.3.1 -Dpackaging=jar -Dfile=$(build-classpath ecj)');

    $jpp->main_section->subst('dashboard_include 1','dashboard_include 0');
    $jpp->main_section->subst('xdoclet_include 1','xdoclet_include 0');

    $jpp->get_section('prep')->push_body(q{
subst 's,<module>dashboard-maven-plugin</module>,<!--2.0.8 nocompile<module>dashboard-maven-plugin</module>-->,' mojo-sandbox/pom.xml
subst 's,<module>xdoclet-maven-plugin</module>,<!-- module>xdoclet-maven-plugin</module -->,' pom.xml
});

};

__END__

