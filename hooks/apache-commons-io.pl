#!/usr/bin/perl -w

require 'set_fix_repolib_project.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # compat mapping 
    $jpp->get_section('install')->unshift_body2_after(
	'%add_to_maven_depmap org.apache.commons %{short_name} %{version} JPP %{name}'."\n",
	'add_to_maven_depmap');
}

__END__
