#!/usr/bin/perl -w

require 'set_fix_repolib_project.pl';
require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # compat mapping 
    $jpp->get_section('install')->unshift_body_after('add_to_maven_depmap',
	'%add_to_maven_depmap org.apache.commons %{short_name} %{version} JPP %{name}'."\n");
}

__END__
