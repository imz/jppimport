#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','',)->push_body('BuildRequires: cglib'."\n");
    $jpp->get_section('package')->push_body('Provides: maven2-plugin-release = 2.0.7'."\n");
    # bug? to report in jpp5 when _without_maven
    # check after rebuild world
    $jpp->get_section('build')->subst(qr'plexus/classworlds', 'plexus/classworlds classworlds');
}

__END__
