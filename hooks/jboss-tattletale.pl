#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/%{name}.conf','');
    $jpp->get_section('prep')->push_body(q!
for i in xmlgraphics-commons commons-io commons-logging xml-commons-jaxp-1.3-apis excalibur/avalon-framework-api excalibur/avalon-framework-impl xerces-j2 xalan-j2 xalan-j2-serializer ; do
%{__ln_s} $(build-classpath $i) tools/docbook/support/lib/`basename $i`.jar
done
!);

}
