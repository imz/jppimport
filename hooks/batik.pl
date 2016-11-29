#!/usr/bin/perl -w

require 'set_osgi.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    foreach $pkg ('','rasterizer','slideshow','squiggle','svgpp','ttf2svg') {
	$spec->get_section('package',$pkg)->push_body('#19119
Provides: xmlgraphics-batik'.($pkg ? "-$pkg" : '').' = 0:%version-%release
Obsoletes: xmlgraphics-batik'.($pkg ? "-$pkg" : '').' < 0:%version
Conflicts: xmlgraphics-batik < 0:%version
Conflicts: xmlgraphics-batik-rasterizer < 0:%version
Conflicts: xmlgraphics-batik-slideshow < 0:%version
Conflicts: xmlgraphics-batik-svgpp < 0:%version
Conflicts: xmlgraphics-batik-ttf2svg < 0:%version
');
    }

    $spec->get_section('package','css')->push_body('#32067
Conflicts: batik < 0:1.8-alt1_1
');


    &add_missingok_config($spec, '/etc/rasterizer.conf','rasterizer');
    &add_missingok_config($spec, '/etc/slideshow.conf','slideshow');
    &add_missingok_config($spec, '/etc/squiggle.conf','squiggle');
    &add_missingok_config($spec, '/etc/svgpp.conf','svgpp');
    &add_missingok_config($spec, '/etc/ttf2svg.conf','ttf2svg');
    $spec->get_section('build')->unshift_body(q!
export ANT_OPTS="-Xmx512m"
# due to javadoc x86_64 out of memory
subst 's,maxmemory="128m",maxmemory="512m",' build.xml
!);

    $spec->get_section('install')->push_body('
mkdir -p $RPM_BUILD_ROOT%_javadir/xmlgraphics-batik
pushd $RPM_BUILD_ROOT%_javadir/xmlgraphics-batik'."\n");

    foreach my $i ('anim','awt-util','bridge','codec','css','dom','ext','extension','gui-util','gvt','parser','script','svg-dom','svggen','swing','transcoder','util','xml') {
	$spec->get_section('install')->push_body("  ln -s ../batik/batik-$i.jar batik-$i.jar\n");
	$spec->get_section('files','')->push_body("%_javadir/xmlgraphics-batik/batik-$i.jar\n");
    }
    foreach my $i ('rasterizer') {
	$spec->get_section('install')->push_body("  ln -s ../batik-$i.jar $i.jar\n");
	$spec->get_section('files','rasterizer')->push_body("%_javadir/xmlgraphics-batik/$i.jar\n");
    }
    $spec->get_section('install')->push_body('popd'."\n");

    $spec->get_section('install')->push_body('
# due to #19119
#1: xmlgraphics-batik         error: unpacking of archive failed on file
#/usr/share/java/batik: cpio: rename failed - Is a directory
#E: Some errors occurred while running transaction
%pre
[ -d /usr/share/java/batik ] && rm -rf /usr/share/java/batik ||:
');
    $spec->get_section('files','')->push_body('%_javadir/batik
%dir %_javadir/xmlgraphics-batik
');
}

__END__
