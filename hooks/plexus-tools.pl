#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->add_patch('',STRIP=>1);
    $jpp->get_section('package','')->push_body(q!
#Provides: plexus-cdc = %version
#Obsoletes: plexus-cdc < %version
#Obsoletes: plexus-cli
Requires: plexus-cdc

%package        -n plexus-cdc
Version:        1.0
Epoch:          0
Summary:        Plexus Component Descriptor Creator
License:        Apache Software License
Group:          Development/Java
URL:            http://plexus.codehaus.org/

%description -n plexus-cdc
The Plexus project seeks to create end-to-end developer tools for
writing applications. At the core is the container, which can be
embedded or for a full scale application server. There are many
reusable components for hibernate, form processing, jndi, i18n,
velocity, etc. Plexus also includes an application server which
is like a J2EE application server, without all the baggage.

!."\n");

    $jpp->get_section('install')->subst(
	qr'add_to_maven_depmap org.codehaus.plexus plexus-cdc',
	'add_to_maven_depmap_at plexus-cdc org.codehaus.plexus plexus-cdc');

    $jpp->get_section('install')->push_body(q!
ln -s tools-cdc-1.0.jar %buildroot/usr/share/java/plexus/tools-cdc.jar
!."\n");

    $jpp->get_section('files','')->push_body(q!
%exclude /etc/maven/fragments/plexus-cdc
%exclude /usr/share/java/plexus/cdc.jar
%exclude /usr/share/java/plexus/tools-cdc*
%exclude /usr/share/maven2/poms/JPP.plexus-tools-cdc*

%files -n plexus-cdc
/etc/maven/fragments/plexus-cdc
/usr/share/java/plexus/cdc.jar
/usr/share/java/plexus/tools-cdc*jar
/usr/share/maven2/poms/JPP.plexus-tools-cdc*
!."\n");

};

__END__
#/usr/share/java/plexus/tools-cli*
#/usr/share/java/plexus/cli.jar
#/usr/share/maven2/poms/JPP.plexus-tools-cli.pom
