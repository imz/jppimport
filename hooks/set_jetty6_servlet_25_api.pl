#!/usr/bin/perl -w

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jetty6-servlet-2.5-api'."\n");
}

__END__
