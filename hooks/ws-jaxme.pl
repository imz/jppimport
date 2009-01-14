#!/usr/bin/perl -w

require 'set_target_14.pl';

push @PREHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # hack around hsqldb and dual core CPU (ws-jaxme 0.5.2)
    $jpp->get_section('build')->subst(qr'ant all javadoc', "ant all\nant javadoc");
}


push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: xmldb-api-sdk'."\n");
    $jpp->get_section('package','')->unshift_body('Requires: xmldb-api-sdk'."\n");
}

__END__
BuildRequires: jakarta-commons-codec
Requires: jakarta-commons-codec
# taken from fedora
Source11:        ws-jaxme-bind-MANIFEST.MF
Patch3:         ws-jaxme-jdk16.patch
Patch5:         ws-jaxme-use-commons-codec.patch

%prep
...
#TODO
#%patch3 -p1
%patch5 -b .sav
subst 's,<pathelement location="\${preqs}/ant.jar"/>,<pathelement location="${preqs}/ant.jar"/><pathelement location="${preqs}/commons-codec.jar"/>,' ant/jm.xml

%build
...
 hsqldb \
+commons-codec

...
mkdir -p META-INF
cp -p %{SOURCE11} META-INF/MANIFEST.MF
touch META-INF/MANIFEST.MF
zip -u dist/jaxmeapi-%{version}.jar META-INF/MANIFEST.MF
