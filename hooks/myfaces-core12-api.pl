#!/usr/bin/perl -w

require 'set_apache_translation.pl';

# 6.0 hook
push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('BuildRequires: jstl'."\n");

}

__END__
