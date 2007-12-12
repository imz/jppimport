#!/usr/bin/perl -w

require 'set_without_extra.pl';
require 'set_add_jspapi_dep.pl';
require 'set_fix_homedir_macro.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    map {$_->subst(qr'%{_sysconfdir}/init.d','%{_initdir}')} @{$jpp->get_sections()};

# TODO: investigate problems with deps on xml-commons-apis.jar
    $jpp->get_section('package','')->unshift_body('%add_findreq_skiplist /usr/share/jetty5/ext/xml-commons-apis.jar'."\n");
    $jpp->get_section('package','')->unshift_body('%add_findreq_skiplist /usr/share/jetty5/ext/jspapi.jar'."\n");


# # TODO: subst in jelly.init
#    daemon --user $JETTY_USER $JETTY_SCRIPT start
#    start_daemon --user $JETTY_USER $JETTY_SCRIPT
#    daemon --user $JETTY_USER $JETTY_SCRIPT stop
#    stop_daemon --user $JETTY_USER $JETTY_SCRIPT
    $jpp->copy_to_sources('jetty5.init');

    $jpp->copy_to_sources('jetty-OSGi-MANIFEST.MF');
    $jpp->get_section('package','')->push_body('Source4:        jetty-OSGi-MANIFEST.MF'."\n");
    $jpp->get_section('build')->push_body('
# inject OSGi manifests
mkdir -p META-INF
cp %{SOURCE4} META-INF/MANIFEST.MF
zip -u lib/org.mortbay.jetty.jar META-INF/MANIFEST.MF
');



}
