#!/usr/bin/perl -w

require 'add_missingok_config.pl';

#xmlgraphics-batik-rasterizer#0:1.7-alt1_5jpp5   /etc/xmlgraphics-batik-rasterizer.conf
#xmlgraphics-batik-slideshow#0:1.7-alt1_5jpp5    /etc/xmlgraphics-batik-slideshow.conf
#xmlgraphics-batik-squiggle#0:1.7-alt1_5jpp5     /etc/xmlgraphics-batik-squiggle.conf
#xmlgraphics-batik-svgpp#0:1.7-alt1_5jpp5        /etc/xmlgraphics-batik-svgpp.conf
#xmlgraphics-batik-ttf2svg#0:1.7-alt1_5jpp5      /etc/xmlgraphics-batik-ttf2svg.conf

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/%{name}-rasterizer.conf','rasterizer');
    &add_missingok_config($jpp, '/etc/%{name}-slideshow.conf','slideshow');
    &add_missingok_config($jpp, '/etc/%{name}-squiggle.conf','squiggle');
    &add_missingok_config($jpp, '/etc/%{name}-svgpp.conf','svgpp');
    &add_missingok_config($jpp, '/etc/%{name}-ttf2svg.conf','ttf2svg');
}
