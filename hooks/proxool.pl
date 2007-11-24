#!/usr/bin/perl -w

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    # todo: remove when hibernate3 will be built
    $jpp->get_section('package','')->unshift_body('%define _without_hibernate 1'."\n");
    $jpp->get_section('prep')->subst(qr'^%patch4','#%patch4');
    # end to remove
    #$jpp->get_section('build')->unshift_body_after('ln -sf $(build-classpath checkstyle) .'."\n", qr'^pushd lib');
    # hack until hibernate3
    $jpp->get_section('build')->subst(qr'build-classpath hibernate3','build-classpath checkstyle');


    $jpp->get_section('package','')->unshift_body('BuildRequires: checkstyle'."\n");
    foreach my $section (@{$jpp->get_sections()}) {
	if ($section->get_type() eq 'package') {
	    $section->subst(qr'hsqldb\s*>=\s*0:1.80','hsqldb');
	}
    }

    $jpp->get_section('build')->subst(qr'build-classpath servlet','build-classpath servletapi');
}
