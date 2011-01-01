#!/usr/bin/perl -w

#use strict;
use warnings;
use File::Basename;

require 'set_osgi.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    my $fcpath13='/var/ftp/pub/Linux/fedora/linux/releases/13/Everything/x86_64/os/Packages/';
    my $fcpath14='/var/ftp/pub/Linux/fedora/linux/releases/14/Everything/x86_64/os/Packages/';

    my $name=$jpp->get_section('package','')->get_tag('Name');
    if ($name eq 'jetty6') {
	#&unpack_fc_rpm($jpp,$fcpath13.'jetty-6.1.21-4.fc13.noarch.rpm');
	#&merge_osgi_manifest($jpp,'/usr/share/java/jetty6/jetty6-util.jar','/usr/share/jetty/lib/jetty-util-6.1.21.jar');
	#&merge_osgi_manifest($jpp,'/usr/share/java/jetty6/jetty6.jar','/usr/share/jetty/lib/jetty-6.1.21.jar');
	&unpack_fc_rpm($jpp,$fcpath14.'jetty-6.1.24-1.fc14.noarch.rpm');
	&merge_osgi_manifest($jpp,'/usr/share/java/jetty6/jetty6-util.jar','/usr/share/jetty/lib/jetty-util-6.1.24.jar');
	&merge_osgi_manifest($jpp,'/usr/share/java/jetty6/jetty6.jar','/usr/share/jetty/lib/jetty-6.1.24.jar');
    } elsif ($name eq 'jakarta-commons-lang') {
	&unpack_fc_rpm($jpp,$fcpath13.'jakarta-commons-lang-2.4-1.fc13.x86_64.rpm');
	&merge_osgi_manifest($jpp,'/usr/share/java/commons-lang.jar','/usr/share/java/jakarta-commons-lang-2.4.jar');
    } elsif ($name eq 'jakarta-oro') {
	&unpack_fc_rpm($jpp,$fcpath14.'jakarta-oro-2.0.8-6.3.fc12.x86_64.rpm');
	&merge_osgi_manifest($jpp,'/usr/share/java/jakarta-oro.jar','/usr/share/java/jakarta-oro-2.0.8.jar');
    } elsif ($name eq 'jdom') {
	&unpack_fc_rpm($jpp,$fcpath14.'jdom-1.1.1-1.fc13.x86_64.rpm');
	&merge_osgi_manifest($jpp,'/usr/share/java/jdom.jar','/usr/share/java/jdom-1.1.1.jar');
    } elsif ($name eq 'wsdl4j') {
	&unpack_fc_rpm($jpp,$fcpath14.'wsdl4j-1.5.2-7.6.fc12.x86_64.rpm');
	&merge_osgi_manifest($jpp,'/usr/share/java/wsdl4j.jar','/usr/share/java/wsdl4j-1.5.2.jar');
    } elsif ($name eq 'xerces-j2') {
	&unpack_fc_rpm($jpp,$fcpath14.'xerces-j2-2.9.0-4.fc14.noarch.rpm');
	&merge_osgi_manifest($jpp,'/usr/share/java/xerces-j2.jar','/usr/share/java/xerces-j2-2.9.0.jar');
    } elsif ($name eq 'xml-commons') {
	&unpack_fc_rpm($jpp,$fcpath14.'xml-commons-resolver-1.2-4.fc14.noarch.rpm');
	&merge_osgi_manifest($jpp,'/usr/share/java/xml-commons-resolver12.jar','/usr/share/java/xml-commons-resolver-1.2.jar');
	&unpack_fc_rpm($jpp,$fcpath14.'xml-commons-apis-1.4.01-1.fc13.noarch.rpm');
	&merge_osgi_manifest($jpp,'/usr/share/java/xml-commons-jaxp-1.3-apis.jar','/usr/share/java/xml-commons-apis-1.4.01.jar');
	&merge_osgi_manifest($jpp,'/usr/share/java/xml-commons-jaxp-1.3-apis-ext.jar','/usr/share/java/xml-commons-apis-ext-1.4.01.jar');
	$jpp->get_section('package','resolver12')->push_body("AutoReq: yes,noosgi\n");
	$jpp->get_section('package','jaxp-1.3-apis')->push_body("AutoReq: yes,noosgi\n");
    } elsif ($name eq 'xalan-j2') {
	&unpack_fc_rpm($jpp,$fcpath14.'xalan-j2-2.7.1-1.fc14.noarch.rpm');
	&merge_osgi_manifest($jpp,'/usr/share/java/xalan-j2-serializer.jar','/usr/share/java/xalan-j2-serializer-2.7.1.jar');
    } elsif ($name eq 'xmlgraphics-fop') {
	&unpack_fc_rpm($jpp,$fcpath14.'fop-0.95-5.fc14.noarch.rpm');
	&merge_osgi_manifest($jpp,'/usr/share/java/xmlgraphics-fop.jar','/usr/share/java/fop-0.95.jar');
    } elsif ($name eq 'xmlgraphics-batik') {
	&unpack_fc_rpm($jpp,$fcpath14.'batik-1.7-6.fc12.noarch.rpm');
	foreach my $i ('anim','awt-util','bridge','codec','css','dom','ext','extension','gui-util','gvt','parser','script','svg-dom','svggen','swing','transcoder','util','xml') {
	    &merge_osgi_manifest($jpp,'/usr/share/java/xmlgraphics-batik/'.$i.'.jar','/usr/share/java/batik/batik-'.$i.'-1.7.jar');
	}

    }

};

sub unpack_fc_rpm {
    my ($jpp,$fcrpm)=@_;
    my $PWD=`pwd`;
    chomp $PWD;
    chdir $jpp->{SOURCEDIR};
    system("rpm2cpio '$fcrpm' | cpio -idmu --quiet --no-absolute-filenames") && die "rpm2cpio failed on srpm $fcrpm";
    chdir $PWD;
}



sub merge_osgi_manifest {
    my ($jpp,$jppjar,$fcjar)=@_;
    my $PWD=`pwd`;
    chomp $PWD;
    my $jarpath=$jpp->{SOURCEDIR}.'/'.dirname($fcjar);
    #print STDERR "jarpath=$jarpath\n";
    chdir $jarpath;
    #system('ls', '-l') && die "$fcjar: ls failed";
    system('unzip','-q','-o', basename($fcjar)) && die "$fcjar: unzip failed";
    my $manifestname=basename($fcjar).'-OSGi-MANIFEST.MF';
    system('cp','META-INF/MANIFEST.MF',$manifestname);
    system('rm','-rf','META-INF');
    chdir $PWD;
    my $srcid=$jpp->add_source($manifestname, FILE=>$jarpath.'/'.$manifestname);
    $jpp->get_section('install')->push_body('
# inject OSGi manifest '.$manifestname.'
rm -rf META-INF
mkdir -p META-INF
cp %{SOURCE'.$srcid.'} META-INF/MANIFEST.MF
zip -u %buildroot'.$jppjar.' META-INF/MANIFEST.MF
# end inject OSGi manifest '.$manifestname.'
');
}

sub vsystem{
    my @args=@_;
    print join(' ',@args)."\n";
    return system(@args);
}

1;
