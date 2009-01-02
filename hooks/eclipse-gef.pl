#!/usr/bin/perl -w
#require 'set_noarch.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
#/.out/eclipse-gef-3.4.1-alt1_2jpp6.noarch.rpm: unpackaged directory: /usr/share/eclipse/dropins/gef/eclipse
#/.out/eclipse-gef-3.4.1-alt1_2jpp6.noarch.rpm: unpackaged directory: /usr/share/eclipse/dropins/gef/eclipse/features
#/.out/eclipse-gef-3.4.1-alt1_2jpp6.noarch.rpm: unpackaged directory: /usr/share/eclipse/dropins/gef/eclipse/plugins
#sisyphus_check: check-subdirs ERROR: subdirectories packaging violation
#hsh-rebuild: eclipse-gef-3.4.1-alt1_2jpp6.src.rpm: sisyphus_check failed.
    $jpp->get_section('files','')->push_body('%dir %_datadir/eclipse/dropins/gef/eclipse
%dir %_datadir/eclipse/dropins/gef/eclipse/features
%dir %_datadir/eclipse/dropins/gef/eclipse/plugins
');
};
