#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
my @obsolete=qw/
geronimo-corba-3.0-apis			geronimo-specs-corba
geronimo-ejb-2.1-api			geronimo-specs-ejb
geronimo-j2ee-connector-1.5-api		geronimo-specs-j2ee-connector
geronimo-j2ee-deployment-1.1-api	geronimo-specs-j2ee-deployment
geronimo-j2ee-management-1.0-api	geronimo-specs-j2ee-management
geronimo-jacc-1.0-api			geronimo-specs-j2ee-jacc
geronimo-jaf-1.0.2-api			geronimo-specs-activation
geronimo-javamail-1.3.1-api		geronimo-specs-javamail
geronimo-jaxr-1.0-api			geronimo-specs-jaxr
geronimo-jaxrpc-1.1-api			geronimo-specs-jaxrpc
geronimo-jms-1.1-api			geronimo-specs-jms
geronimo-jsp-2.0-api			geronimo-specs-jsp
geronimo-jta-1.0.1B-api			geronimo-specs-jta
geronimo-qname-1.1-api			geronimo-specs-qname
geronimo-saaj-1.1-api			geronimo-specs-saaj
geronimo-servlet-2.4-api		geronimo-specs-servlet
/;
    while (scalar @obsolete) {
	my $new = shift @obsolete;
	my $old = shift @obsolete;
	$jpp->get_section('package','-n '.$new)->push_body('Obsoletes: '.$old.' < 1.1'."\n");
	$jpp->get_section('package','-n '.$new)->push_body('Provides: '.$old.' = 1.1'."\n");
    }
}
