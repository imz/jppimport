#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
}

__END__
    $spec->get_section('install')->push_body('# jakarta compat
ln -s %{short_name}.jar %buildroot%_javadir/jakarta-%{short_name}.jar
'."\n");
    # hack til eclipse4 update
    $spec->get_section('package','')->unshift_body('Provides: osgi(org.apache.commons.net) = 2.0.0'."\n");
