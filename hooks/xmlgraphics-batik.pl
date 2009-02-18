#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/%{name}-rasterizer.conf','rasterizer');
    &add_missingok_config($jpp, '/etc/%{name}-slideshow.conf','slideshow');
    &add_missingok_config($jpp, '/etc/%{name}-squiggle.conf','squiggle');
    &add_missingok_config($jpp, '/etc/%{name}-svgpp.conf','svgpp');
    &add_missingok_config($jpp, '/etc/%{name}-ttf2svg.conf','ttf2svg');
    $jpp->get_section('install')->push_body('
pushd $RPM_BUILD_ROOT%_javadir
ln -s xmlgraphics-batik batik
popd
');
    $jpp->get_section('files','')->push_body('%_javadir/batik
');
}
