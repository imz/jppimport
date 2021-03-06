#!/usr/bin/perl -w

#use strict;
use warnings;
use File::Basename;
use lib $ENV{'HOME'}.'/src/repo/jppimport.git/hooks';
require 'set_osgi.pl';

push @SPECHOOKS, 
 sub {
    my ($spec,) = @_;
    my $fcpath14='/var/ftp/pub/Linux/fedora/linux/releases/14/Everything/x86_64/os/Packages/';
    my $fcpath18='/var/ftp/pub/Linux/fedora/linux/development/18/x86_64/os/Packages/';
    my $fcpathRH='/var/ftp/pub/Linux/fedora/linux/development/rawhide/x86_64/os/Packages/';
    my $name=$spec->get_section('package','')->get_tag('Name');
    if ($name eq 'jetty6') {
    } elsif ($name eq 'apache-commons-httpclient' or $name eq 'jakarta-commons-httpclient') {
	&unpack_fc_rpm($spec,$fcpath14.'jakarta-commons-httpclient-3.1-1.fc14.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/commons-httpclient.jar','/usr/share/java/jakarta-commons-httpclient-3.1.jar');
    } elsif ($name eq 'apache-commons-el') {
	&unpack_fc_rpm($spec,$fcpathRH.'a/apache-commons-el-1.0-24.fc18.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/commons-el.jar','/usr/share/java/apache-commons-el-1.0.jar');
    } elsif ($name eq 'apache-commons-logging') {
	&unpack_fc_rpm($spec,$fcpathRH.'a/apache-commons-logging-1.1.1-17.fc17.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/commons-logging.jar','/usr/share/java/apache-commons-logging.jar');
    } elsif ($name eq 'apache-commons-io') {
	#&unpack_fc_rpm($spec,$fcpathRH.'a/apache-commons-io-2.0.1-3.fc16.noarch.rpm');
	#&merge_osgi_manifest($spec,'/usr/share/java/commons-io.jar','/usr/share/java/apache-commons-io.jar');
    } elsif ($name eq 'apache-commons-el') {
	&unpack_fc_rpm($spec,$fcpathRH.'a/apache-commons-el-1.0-3.fc16.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/commons-io.jar','/usr/share/java/apache-commons-io.jar');
    } elsif ($name eq 'apache-commons-codec') {
	&unpack_fc_rpm($spec,$fcpathRH.'a/apache-commons-codec-1.7-4.fc19.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/commons-codec.jar','/usr/share/java/commons-codec.jar');
# no need; it contains
#    } elsif ($name eq 'apache-commons-lang') {
#	&unpack_fc_rpm($spec,$fcpath14.'apache-commons-lang-2.4-1.fc14.x86_64.rpm');
#	&merge_osgi_manifest($spec,'/usr/share/java/commons-lang.jar','/usr/share/java/jakarta-commons-lang-2.4.jar');
# no need; it contains
#    } elsif ($name eq 'apache-commons-net') {
#	&unpack_fc_rpm($spec,$fcpath14.'apache-commons-net-2.0-6.fc14.noarch.rpm');
#	&merge_osgi_manifest($spec,'/usr/share/java/commons-net.jar','/usr/share/java/apache-commons-net-2.0.jar');
    } elsif ($name eq 'jakarta-oro') {
	&unpack_fc_rpm($spec,$fcpath14.'jakarta-oro-2.0.8-6.3.fc12.x86_64.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/jakarta-oro.jar','/usr/share/java/jakarta-oro-2.0.8.jar');
    } elsif ($name eq 'jdom') {
	&unpack_fc_rpm($spec,$fcpathRH.'jdom-1.1.2-2.fc17.x86_64.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/jdom.jar','/usr/share/java/jdom.jar');
    } elsif ($name eq 'objectweb-asm') {
	&unpack_fc_rpm($spec,$fcpathRH.'objectweb-asm-3.3.1-2.fc17.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/objectweb-asm/asm-all.jar','/usr/share/java/objectweb-asm/asm-all.jar');
    } elsif ($name eq 'rhino') {
	&unpack_fc_rpm($spec,$fcpathRH.'rhino-1.7-0.10.r3.fc17.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/js.jar','/usr/share/java/js-1.7.jar');
    } elsif ($name eq 'sac') {
	&unpack_fc_rpm($spec,$fcpathRH.'sac-1.3-11.fc16.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/sac.jar','/usr/share/java/sac.jar');
    } elsif ($name eq 'wsdl4j') {
	&unpack_fc_rpm($spec,$fcpath14.'wsdl4j-1.5.2-7.6.fc12.x86_64.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/wsdl4j.jar','/usr/share/java/wsdl4j-1.5.2.jar');
    } elsif ($name eq 'xerces-j2') {
	&unpack_fc_rpm($spec,$fcpath14.'xerces-j2-2.9.0-4.fc14.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/xerces-j2.jar','/usr/share/java/xerces-j2-2.9.0.jar');
    } elsif ($name eq 'xml-commons') {
	&unpack_fc_rpm($spec,$fcpathRH.'x/xml-commons-resolver-1.2-10.fc19.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/xml-commons-resolver12.jar','/usr/share/java/xml-commons-resolver-1.2.jar');
	&unpack_fc_rpm($spec,$fcpathRH.'x/xml-commons-apis-1.4.01-8.fc19.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/xml-commons-jaxp-1.3-apis.jar','/usr/share/java/xml-commons-apis.jar');
	&merge_osgi_manifest($spec,'/usr/share/java/xml-commons-jaxp-1.3-apis-ext.jar','/usr/share/java/xml-commons-apis-ext.jar');
	$spec->get_section('package','resolver12')->push_body("AutoReq: yes,noosgi\n");
	$spec->get_section('package','jaxp-1.3-apis')->push_body("AutoReq: yes,noosgi\n");
    } elsif ($name eq 'xalan-j2') {
	&unpack_fc_rpm($spec,$fcpathRH.'xalan-j2-2.7.1-8.fc17.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/xalan-j2-serializer.jar','/usr/share/java/xalan-j2-serializer.jar');
    } elsif ($name eq 'xmlgraphics-fop') {
	&unpack_fc_rpm($spec,$fcpathRH.'f/fop-1.0-18.fc17.noarch.rpm');
	&merge_osgi_manifest($spec,'/usr/share/java/xmlgraphics-fop/fop.jar','/usr/share/java/fop.jar');
    } elsif ($name eq 'xmlgraphics-batik') {
	&unpack_fc_rpm($spec,$fcpathRH.'batik-1.7-12.fc16.noarch.rpm');
	foreach my $i ('anim','awt-util','bridge','codec','css','dom','ext','extension','gui-util','gvt','parser','script','svg-dom','svggen','swing','transcoder','util','xml') {
	    &merge_osgi_manifest($spec,'/usr/share/java/xmlgraphics-batik/batik-'.$i.'.jar','/usr/share/java/batik/batik-'.$i.'.jar');
	}
    } else {
	warn "no need for OSGi MANIFEST or not found.";
    }

};

sub unpack_fc_rpm {
    my ($spec,$fcrpm)=@_;
    my $PWD=`pwd`;
    chomp $PWD;
    chdir $spec->{SOURCEDIR};
    system("rpm2cpio '$fcrpm' | cpio -idmu --quiet --no-absolute-filenames") && die "rpm2cpio failed on srpm $fcrpm";
    chdir $PWD;
}



sub merge_osgi_manifest {
    my ($spec,$specjar,$fcjar)=@_;
    my $PWD=`pwd`;
    chomp $PWD;
    my $jarpath=$spec->{SOURCEDIR}.'/'.dirname($fcjar);
    #print STDERR "jarpath=$jarpath\n";
    chdir $jarpath;
    #system('ls', '-l') && die "$fcjar: ls failed";
    system('unzip','-q','-o', basename($fcjar)) && die "$fcjar: unzip failed";
    my $manifestname=basename($fcjar).'-OSGi-MANIFEST.MF';
    system('cp','META-INF/MANIFEST.MF',$manifestname);
    system('rm','-rf','META-INF');
    chdir $PWD;
    my $srcid=$spec->add_source($manifestname, FILE=>$jarpath.'/'.$manifestname);
    $spec->get_section('install')->push_body('
# inject OSGi manifest '.$manifestname.'
rm -rf META-INF
mkdir -p META-INF
cp %{SOURCE'.$srcid.'} META-INF/MANIFEST.MF
# update even MANIFEST.MF already exists
# touch META-INF/MANIFEST.MF
zip -v %buildroot'.$specjar.' META-INF/MANIFEST.MF
# end inject OSGi manifest '.$manifestname.'
');
}

sub vsystem{
    my @args=@_;
    print join(' ',@args)."\n";
    return system(@args);
}

1;
