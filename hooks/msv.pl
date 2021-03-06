#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub  {
    my ($spec,) = @_;
    &add_missingok_config($spec,'/etc/java/msv.conf','msv');

    $spec->get_section('description','xsdlib')->push_body('
 Sun XML Datatypes Library. An implementation of W3C XML Schema Part 2.
');

}

__END__
#    $spec->get_section('package','msv')->push_body('Provides: msv = %version'."\n");
#    $spec->get_section('package','msv')->push_body('Obsoletes: msv < 1.3'."\n");
#    $spec->get_section('package','xsdlib')->push_body('Conflicts: msv < 1.3'."\n");
#    $spec->get_section('package','xsdlib')->push_body('Provides: xsdlib'."\n");

