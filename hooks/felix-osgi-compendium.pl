#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # till the new version of apache-commons-chain-1.3-alt1_0.r831527.5jpp6.src.rpm appear
    $jpp->get_section('package','')->subst(qr'^Requires: tomcat6-servlet-2.5-api','#Requires: tomcat6-servlet-2.5-api');
};

__END__
