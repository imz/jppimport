#!/usr/bin/perl -w
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/java/%{name}.conf');
#    $jpp->get_section('build')->subst_body(qr'ant -Dant.build.javac.source=1.5','ant -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5');
};

__END__
