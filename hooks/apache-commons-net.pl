#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body('# jakarta compat
ln -s %{short_name}.jar %buildroot%_javadir/jakarta-%{short_name}.jar
'."\n");
    # hack til eclipse4 update
    $jpp->get_section('package','')->unshift_body('Provides: osgi(org.apache.commons.net) = 2.0.0'."\n");
}

__END__
