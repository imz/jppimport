#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body('# jpackage deprecations
Conflicts: xml-commons-resolver10 < 0:1.3.05
Conflicts: xml-commons-resolver11 < 0:1.3.05
Conflicts: xml-commons-resolver12 < 0:1.3.05
Obsoletes: xml-commons-resolver10 < 0:1.3.05
Obsoletes: xml-commons-resolver11 < 0:1.3.05
Obsoletes: xml-commons-resolver12 < 0:1.3.05
'."\n");
    &add_missingok_config($spec, '/etc/java/%name.conf','');
};

__END__
