#!/usr/bin/perl -w

require 'set_without_extra.pl';
require 'set_add_jspapi_dep.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    # hack around non-jpp mx4j
    $jpp->get_section('build')->unshift_body('rm -f ext/mx4j.jar');
    # 
    $jpp->get_section('build')->subst(qr'ln -s \$\(build-classpath mx4j/mx4j-tools\)','ln -s %{SOURCE100} mx4j-tools.jar');
    map {$_->subst(qr'homedir','catalinahomedir')} @{$jpp->get_sections()};

    map {$_->subst(qr'%{_sysconfdir}/init.d','%{_initdir}')} @{$jpp->get_sections()};

# # TODO: subst in jelly.init

#    daemon --user $JETTY_USER $JETTY_SCRIPT start
#    start_daemon --user $JETTY_USER $JETTY_SCRIPT

#    daemon --user $JETTY_USER $JETTY_SCRIPT stop
#    stop_daemon --user $JETTY_USER $JETTY_SCRIPT

}
