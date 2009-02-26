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
#	$jpp->get_section('package','-n '.$new)->push_body('Provides: '.$old.' = 1.1'."\n");
    }
}
__END__
# TODO:
j2ee-api does not have jms alternative (see hack around spring)


# hack for 1.2 to be built under (old maven2)?
939c939
<   geronimo-spec-corba-2.3/target/geronimo-corba_2.3_spec-null.jar \
---
>   geronimo-spec-corba-2.3/target/geronimo-corba_2.3_spec-1.1.jar \
952c952
<   geronimo-spec-corba-3.0/target/geronimo-corba_3.0_spec-null.jar \
---
>   geronimo-spec-corba-3.0/target/geronimo-corba_3.0_spec-1.1.jar \
965c965
<   geronimo-spec-corba/target/geronimo-spec-corba-null.jar \
---
>   geronimo-spec-corba/target/geronimo-spec-corba-1.0.jar \
1367c1367
<   geronimo-spec-commonj/target/geronimo-commonj_1.1_spec-null.jar \
---
>   geronimo-spec-commonj/target/geronimo-commonj_1.1_spec-1.0.jar \


# hack for 1.1 to be built under java5
diff geronimo-specs.spec.0 geronimo-specs.spec.1 
424c424
<     -Dfile=$(build-classpath mockobjects-j2ee1.4)
---
>     -Dfile=$(build-classpath mockobjects-jdk1.4-j2ee1.4)
