#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/%{name}-rasterizer.conf','rasterizer');
    &add_missingok_config($jpp, '/etc/%{name}-slideshow.conf','slideshow');
    &add_missingok_config($jpp, '/etc/%{name}-squiggle.conf','squiggle');
    &add_missingok_config($jpp, '/etc/%{name}-svgpp.conf','svgpp');
    &add_missingok_config($jpp, '/etc/%{name}-ttf2svg.conf','ttf2svg');
    $jpp->get_section('build')->unshift_body(q!
export ANT_OPTS="-Xmx512m"
# due to javadoc x86_64 out of memory
subst 's,maxmemory="128m",maxmemory="512m",' build.xml
!);

    $jpp->get_section('install')->push_body('
pushd $RPM_BUILD_ROOT%_javadir
# due to #19119
#1: xmlgraphics-batik         error: unpacking of archive failed on file
#/usr/share/java/batik: cpio: rename failed - Is a directory
#E: Some errors occurred while running transaction
#ln -s xmlgraphics-batik batik
  mkdir batik
  pushd batik
    ln -s ../xmlgraphics-batik/* .
  popd
popd
');
    $jpp->get_section('files','')->push_body('%_javadir/batik
');
}
