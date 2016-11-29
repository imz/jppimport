#!/usr/bin/perl -w

require 'set_osgi.pl';
#require 'set_fix_repolib_project.pl';
#require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body('# jpackage compat
Provides:       jakarta-%{short_name} = %version
Obsoletes:      jakarta-%{short_name} < %version
Provides:       %{short_name} = %version
');
    $spec->get_section('install')->push_body('# jpp compat
ln -sf %{name}.jar %{buildroot}%{_javadir}/jakarta-%{short_name}.jar'."\n");
}

__END__
    # compat mapping 
    $spec->get_section('install')->unshift_body_after('add_to_maven_depmap',
	'%add_to_maven_depmap org.apache.commons %{short_name} %{version} JPP %{name}'."\n");
