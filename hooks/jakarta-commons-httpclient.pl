#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('# rename compat
Provides:       jakarta-commons-httpclient = %{epoch}:%version
Obsoletes:      jakarta-commons-httpclient < %{epoch}:%version
');
}

__END__
