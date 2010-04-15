#!/usr/bin/perl -w

require 'set_target_15.pl';
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst_if(qr'jss','jss4',qr'build-classpath');
}
__END__
