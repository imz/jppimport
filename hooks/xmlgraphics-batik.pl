#!/usr/bin/perl -w

require 'add_missingok_config.pl';
require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
# due to #19119
    foreach $pkg ('','rasterizer','slideshow','svgpp','ttf2svg') {
	$jpp->get_section('package',$pkg)->push_body('#19119
Conflicts: batik < 0:%version
Conflicts: batik-rasterizer < 0:%version
Conflicts: batik-slideshow < 0:%version
Conflicts: batik-svgpp < 0:%version
Conflicts: batik-ttf2svg < 0:%version
');
    }

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

    $jpp->get_section('install')->push_body('pushd $RPM_BUILD_ROOT%_javadir/xmlgraphics-batik'."\n");
    foreach my $i ('anim','awt-util','bridge','codec','css','dom','ext','extension','gui-util','gvt','parser','script','svg-dom','svggen','swing','transcoder','util','xml') {
	$jpp->get_section('install')->push_body("  ln -s $i.jar batik-$i.jar\n");
	$jpp->get_section('files','')->push_body("%_javadir/xmlgraphics-batik/batik-$i.jar\n");
    }
    $jpp->get_section('install')->push_body('popd'."\n");

    $jpp->get_section('install')->push_body('
pushd $RPM_BUILD_ROOT%_javadir
  ln -s xmlgraphics-batik batik
popd

# due to #19119
#1: xmlgraphics-batik         error: unpacking of archive failed on file
#/usr/share/java/batik: cpio: rename failed - Is a directory
#E: Some errors occurred while running transaction
%pre
[ -d /usr/share/java/batik ] && rm -rf /usr/share/java/batik ||:
');
    $jpp->get_section('files','')->push_body('%_javadir/batik
');
}

__END__
