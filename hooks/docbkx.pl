#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # hack until maven 2.0.7 will be built ()
    $jpp->get_section('package','')->subst(qr'maven2-plugin-changes','mojo-maven2-plugin-changes');
    $jpp->get_section('package','')->unshift_body('BuildRequires: saxpath xmlgraphics-batik-svgpp xmlgraphics-batik-rasterizer xmlgraphics-batik-slideshow xmlgraphics-batik-squiggle xmlgraphics-batik-ttf2svg'."\n");
};

