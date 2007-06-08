#!/usr/bin/perl -w

require 'set_without_maven.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _without_maven 1'."\n");
    $jpp->get_section('package','')->unshift_body('Obsoletes: wagon = 1.0-alt0.3.alpha5'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-collections concurrent'."\n");
}
__END__
excalibur-cornerstone-connection-api
excalibur-cornerstone-connection-impl
excalibur-cornerstone-sockets-api
excalibur-cornerstone-sockets-impl
excalibur-cornerstone-threads-api
excalibur-cornerstone-threads-impl
excalibur-pool-api
excalibur-pool-impl
excalibur-thread-api
excalibur-thread-impl
jakarta-slide-webdavclient
jetty5
plexus-avalon-personality
plexus-ftpd
plexus-jetty-httpd
