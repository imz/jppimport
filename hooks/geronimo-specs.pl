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

    my $apissec=$jpp->get_section('package','-n geronimo-j2ee-1.4-apis');
    $apissec->unshift_body_before(qr'^Provides:\s+ejb = 0:2.1','### should also provide ejb.jar!
###');
    $apissec->unshift_body_before(qr'^Provides:\s+jaf = 0:1.0.2','### should also provide javamail.jar!
###');
    $apissec->unshift_body_before(qr'^Provides:\s+javamail = 0:1.3.1','###');

    # maven2-208-29+jpp5
    #$jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-site'."\n");

    if (0) {  #'old13-14'
	# 1.2-13,14 specific hack against broken symlinks
	$jpp->get_section('install','')->subst_body_if(qr'-\%{version}','',qr'^  ln -sf ../geronimo-');
	$jpp->get_section('install','')->exclude_body(qr'^  ln -sf spec-');
    } else {
	$jpp->add_patch('geronimo-specs-1.2-pom_xml-alt-kill-parent.patch', STRIP => 0);
	if (1) {
	    $jpp->main_section->push_body(q!# poms moved to corresponding subpackages
Provides:  geronimo-specs-poms = %version-%release
Conflicts: geronimo-specs-poms < 1.2-alt4_17jpp6
Obsoletes: geronimo-specs-poms < 1.2-alt4_17jpp6
!);
	}

# hack added to geronimo-specs-1.2-alt7_16jpp6
# BuildRequires: geronimo-corba-2.3-apis geronimo-qname-1.1-api
# Requires: geronimo-corba-2.3-apis geronimo-qname-1.1-api
#

	my %depfrags;
	$jpp->get_section('install')->map_body(sub { 
	    if (/^\%add_to_maven_depmap(\s+.*\s+JPP\s+)(geronimo-\S+)/) {
		$_='%add_to_maven_depmap_at '."$2 $1$2\n";
		$depfrags{$2}=1;
	    }
					});

	foreach my $section ($jpp->get_sections) {
	    my $pkgname=$section->get_package_name;
	    next unless $section->get_raw_package; # already has an entry
	    next unless $depfrags{$pkgname};
	    $jpp->get_section('files','-n '.$pkgname)->push_body('%{_mavendepmapfragdir}/'.$pkgname."\n");
	}
    }

}
__END__


### TODO: -16: poms are moved to subpackages ... 
-16 breaked the following packages:
ws-commons-axiom-0:1.2.8-alt1_2jpp6
spring2-0:2.5.6-alt3_6.SEC02jpp6
xfire-0:1.2.6-alt10_1jpp5
shale-0:1.0.4-alt5_1jpp5
qdox18-0:1.8-alt1_1jpp5
myfaces-shared12-0:3.0.4-alt3_1jpp5
portals-bridges-0:1.0.4-alt5_4jpp5
myfaces-shared11-0:2.0.5-alt3_2jpp5
struts-0:1.3.10-alt1_2jpp6
plexus-jdo2-0:1.0-alt1_0.a8.1jpp5
myfaces-tomahawk-0:1.1.6-alt5_1jpp5
paranamer-0:1.5-alt1_1jpp6
myfaces-core11-impl-0:1.1.5-alt4_2jpp5
objenesis-0:1.0-alt2_2jpp5
myfaces-core12-impl-0:1.2.3-alt4_1jpp5
grizzly-0:1.7.3.3-alt2_1jpp5
jetty6-0:6.1.22-alt5_2jpp6
excalibur-1:1.0-alt6_0.r508111.14jpp6
eclipse-dtp-1.9.0-alt1_2jpp6
cargo0-0:0.9-alt8_5jpp5

### DEPRECATED ###


# TODO:
j2ee-api does not have jms alternative (see hack around spring)

# patch: remove provides as they are doubtful.
    $jpp->spec_apply_patch(PATCHSTRING => q%
--- geronimo-specs.spec	2012-01-15 22:31:25.000000000 +0200
+++ geronimo-specs.spec	2012-01-15 22:33:15.000000000 +0200
@@ -438,14 +438,16 @@
 # XXX: (dwalluck): section added for backwards compatibility with Fedora 9
 #
 #Provides:      commonj = 0:1.1
-Provides:       ejb = 0:2.1
+### should also provide ejb.jar!
+###Provides:       ejb = 0:2.1
 #Provides:      corba = 0:2.3
 Provides:       j2ee-connector = 0:1.5
 Provides:       j2ee-deployment = 0:1.1
 Provides:       j2ee-management = 0:1.0
 Provides:       jacc = 0:1.0
-Provides:       jaf = 0:1.0.2
-Provides:       javamail = 0:1.3.1
+### should also provide javamail.jar!
+###Provides:       jaf = 0:1.0.2
+###Provides:       javamail = 0:1.3.1
 Provides:       jaxr = 0:1.0
 Provides:       jaxrpc = 0:1.1
 Provides:       jms = 0:1.1
%);

