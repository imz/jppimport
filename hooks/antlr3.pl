#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: antlr3-java'."\n");
};

__END__
