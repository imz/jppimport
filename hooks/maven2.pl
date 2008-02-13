#!/usr/bin/perl -w

#require 'set_bootstrap.pl';
require 'set_target_14.pl';


$spechook = sub {
    my ($jpp, $alt) = @_;
    foreach my $section (@{$jpp->get_sections()}) {
	if ($section->get_type() eq 'package') {
	    #$section->subst(qr'maven-scm\s*>=\s*0:1.0-0.b3.2','maven-scm ');
	}
    }

    $jpp->get_section('package','')->subst(qr'gnu\.regexp','gnu-regexp');
    $jpp->get_section('package','')->subst(qr'BuildRequires: modello-maven-plugin','##BuildRequires: modello-maven-plugin');
    $jpp->get_section('package','')->push_body('BuildRequires: checkstyle-optional jmock'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: saxon-scripts'."\n");
    #$jpp->get_section('package','')->push_body('BuildRequires: maven2-bootstrap-bundle'."\n");
    $jpp->get_section('build')->subst(qr'/%3','/[%%]3');
    $jpp->get_section('build')->subst(qr'%3e','/[%%]3e');

    $jpp->add_patch('maven2-2.0.4-MANTTASKS-44.diff');
# DONE in 11jpp
#    $jpp->get_section('prep')->push_body('%__subst "s,import org.jmock.cglib.Mock,import org.jmock.Mock," maven2-plugins/maven-release-plugin/src/test/java/org/apache/maven/plugins/release/PrepareReleaseMojoTest.java'."\n");

    # to avoid dependency on maven via /etc/mavenrc
    $jpp->get_section('package','')->push_body('%add_findreq_skiplist /usr/share/maven2/bin/mvn'."\n");

    # helped to fix build for maven2-2.0.4-11jpp
    $jpp->get_section('build')->unshift_body_after(q!
###################################
###################################
for i in /usr/share/maven2/default_poms/*.pom /usr/share/maven2/poms/*.pom; do
        [ -e m2_repo/repository/JPP/maven2/default_poms/`basename $i` ] || ln -s $i m2_repo/repository/JPP/maven2/default_poms/
done
###################################
###################################
!, qr!export M2_HOME=`pwd`/maven2/home!);
};

__END__
