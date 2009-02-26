#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: saxpath xmlgraphics-batik-svgpp xmlgraphics-batik-rasterizer xmlgraphics-batik-slideshow xmlgraphics-batik-squiggle xmlgraphics-batik-ttf2svg'."\n");
};

