#!/usr/bin/perl -w

require 'set_bin_755.pl';


push @SPECHOOKS, 
 sub {
    my  ($spec,) = @_;
    $spec->get_section('package','-n python-module-%name')->push_body('
Obsoletes: python-module-antlr2 <= 0:2.7.7-alt11_13jpp6.1
Conflicts: python-module-antlr2 <= 0:2.7.7-alt11_13jpp6.1
'."\n");
};
__END__

