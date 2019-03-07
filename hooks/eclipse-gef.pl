#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
#/.out/eclipse-gef-3.4.1-alt1_2jpp6.noarch.rpm: unpackaged directory: /usr/share/eclipse/dropins/gef/eclipse
#/.out/eclipse-gef-3.4.1-alt1_2jpp6.noarch.rpm: unpackaged directory: /usr/share/eclipse/dropins/gef/eclipse/features
#/.out/eclipse-gef-3.4.1-alt1_2jpp6.noarch.rpm: unpackaged directory: /usr/share/eclipse/dropins/gef/eclipse/plugins
#sisyphus_check: check-subdirs ERROR: subdirectories packaging violation
#hsh-rebuild: eclipse-gef-3.4.1-alt1_2jpp6.src.rpm: sisyphus_check failed.
    $spec->get_section('files','')->push_body('%dir %_datadir/eclipse/dropins/gef/eclipse
%dir %_datadir/eclipse/dropins/gef/eclipse/features
%dir %_datadir/eclipse/dropins/gef/eclipse/plugins
');

    # different noarches due to .qualifier in version (is replaced by timestamp)
    $spec->get_section('build')->subst_body(qr'pdebuild -f org.eclipse.gef.examples','pdebuild -f org.eclipse.gef.examples -a "-DforceContextQualifier=%{contextQualifier} -DJAVADOC14_HOME=%{java_home}/bin"');
};
