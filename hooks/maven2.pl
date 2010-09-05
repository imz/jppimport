#!/usr/bin/perl -w

#does not applied :(
#require 'set_target_15.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('BuildRequires: maven-shared-archiver'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: jakarta-commons-digester18 jakarta-commons-parent'."\n");
    # TODO: update maven-surefire;
    # do not want to update(revert) plexus-archiver from a8 to a7.
    # so disable maven2-plugins-catch-uncaught-exceptions.patch
    $jpp->get_section('prep')->subst(qr'^\%patch4\s','#patch4 ');
    # and make other similar patches
    $jpp->add_patch('maven2-2.0.8-alt-plexus-archiver-a8.patch',STRIP=>1);

};

__END__

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
