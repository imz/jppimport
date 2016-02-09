#!/usr/bin/perl -w

require 'set_apache_obsoletes_epoch1.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body('Provides: jakarta-commons-cli = %version'."\n");

}

__END__
