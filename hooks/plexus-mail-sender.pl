#!/usr/bin/perl -w

require 'set_clean_surefire23.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # maven2-208-29
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-site'."\n");
};

__END__
