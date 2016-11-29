#!/usr/bin/perl -w

require 'set_osgi.pl';
require 'add_missingok_config.pl';
require 'set_skip_usr_bin_run.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    &add_missingok_config($spec, '/etc/fop.conf','');
    $spec->get_section('package','')->push_body(q!
Provides: xmlgraphics-fop = %{epoch}:%version-%release
Obsoletes: xmlgraphics-fop <= 0:1.0-alt3_4jpp6
Conflicts: xmlgraphics-fop <= 0:1.0-alt3_4jpp6
!);
    $spec->get_section('install')->push_body(q!
# xmlgraphics-fop compat symlinks
ln -s fop.jar %buildroot%_javadir/xmlgraphics-fop.jar
ln -s fop %buildroot%_bindir/xmlgraphics-fop
!);

    $spec->get_section('files')->push_body(q!# compat symlinks
%_javadir/xmlgraphics-fop.jar
%_bindir/xmlgraphics-fop
!);
};

__END__
