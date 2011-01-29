#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
}
__END__
5.0
    # hack ! geronimo poms !
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-specs-poms'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: junitperf'."\n");
    # tests fails :(
    $jpp->get_section('build')->unshift_body_after('-Dmaven.test.skip=true \\'."\n", qr'mvn-jpp');

    # bug?.(jpp5)
    #$jpp->get_section('package','')->subst_if('avalon-framework','excalibur-avalon-framework', qr'BuildRequires:');

# in that case symlinks should be made too
#    $jpp->get_section('package','avalon-framework')->push_body('Provides: avalon-framework = %framework_version');
#    $jpp->get_section('package','avalon-logkit')->push_body('Provides: avalon-logkit = 2.1');
