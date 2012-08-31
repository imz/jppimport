#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body('# jakarta compat
ln -s %{short_name}.jar %buildroot%_javadir/jakarta-%{short_name}.jar
'."\n");
}

__END__
