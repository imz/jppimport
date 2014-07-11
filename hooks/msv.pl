#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub  {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/java/msv.conf','msv');

#    $jpp->get_section('package','msv')->push_body('Provides: msv = %version'."\n");
#    $jpp->get_section('package','msv')->push_body('Obsoletes: msv < 1.3'."\n");
#    $jpp->get_section('package','xsdlib')->push_body('Conflicts: msv < 1.3'."\n");
#    $jpp->get_section('package','xsdlib')->push_body('Provides: xsdlib'."\n");
#    $jpp->get_section('install')->push_body('ln -s msv-core.jar %buildroot%_javadir/msv.jar'."\n");
#    $jpp->get_section('install')->push_body('# compat depmap
#%add_to_maven_depmap msv msv %{version} JPP %{name}
#%add_to_maven_depmap msv xsdlib %{version} JPP %{name}-xsdlib
#'."\n");

    $jpp->get_section('description','xsdlib')->push_body('
 Sun XML Datatypes Library. An implementation of W3C XML Schema Part 2.
');

}

__END__
