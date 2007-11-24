#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # todo: fix in next tomcat build!
    #ile /usr/share/java/jspapi.jar conflicts between attempted installs of tomcat5-jsp-2.0-api-5.5.24-alt3_3jpp1.7 and geronimo-specs-jsp-1.0-alt0.M5.8
    $jpp->get_section('package','')->subst(qr'Requires:\s*jspapi','Requires: tomcat5-jsp-2.0-api');
}
