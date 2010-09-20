#!/usr/bin/perl -w

#does not applied :(
#require 'set_target_15.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _without_bootstrap 1'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: maven-shared-archiver'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: jakarta-commons-digester18 jakarta-commons-parent excalibur-avalon-framework'."\n");
    # maven2-plugin-javadoc reqs avalon-framework pom due to pom dependencies
    $jpp->get_section('package','plugin-javadoc')->push_body('Requires: excalibur-avalon-framework'."\n");
    # NO NEED: already in 6.0 common poms
    #$jpp->get_section('package','plugin-javadoc')->push_body('Requires: excalibur'."\n");

    #unless ('revert to a7') {
	# I do not want to update(revert) plexus-archiver from a8 to a7.
	# so disable maven2-plugins-catch-uncaught-exceptions.patch
	$jpp->get_section('prep')->subst(qr'^\%patch4\s','#patch4 ');
	# and make other similar patches
	$jpp->add_patch('maven2-2.0.8-alt-plexus-archiver-a8.patch',STRIP=>1);
    #}
    # TODO: update maven-surefire;

    # tmp hack over sandbox error :(
    #$jpp->get_section('package','')->push_body('ExclusiveArch: %ix86'."\n");
};

__END__
    #$jpp->get_section('package','')->push_body('Provides: maven2-plugin-enforcer'."\n");


# 2.0.7
#require 'set_bootstrap.pl';
require 'set_target_14.pl';
#require 'set_without_maven.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('BuildRequires: avalon-framework'."\n");
    $jpp->get_section('package','plugin-idea')->subst('dom4j >= 1.6.1','dom4j >= 0:1.6.1');
    # due to
  # Requires: dom4j >= 1.6.1
  # Requires: dom4j >= 0:1.6.1

    $jpp->get_section('build')->unshift_body_before('
# avalon hack
$M2_HOME/bin/mvn -s %{maven_settings_file} $MAVEN_OPTS \
      install:install-file -DgroupId=avalon-framework -DartifactId=avalon-framework \
      -Dversion=4.1.3 -Dpackaging=jar -Dfile=$(build-classpath avalon-framework)

',qr'# Build everything');
};



__DATA__
