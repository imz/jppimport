#!/usr/bin/perl -w

#use strict;
use warnings;
use File::Basename;

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    my $fcpath='/var/ftp/pub/Linux/fedora/linux/releases/13/Everything/x86_64/os/Packages/';
    my $name=$jpp->get_section('package','')->get_tag('Name');
    if ($name eq 'jetty6') {
	&unpack_fc_rpm($jpp,$fcpath.'jetty-6.1.21-4.fc13.noarch.rpm');
	&merge_osgi_manifest($jpp,'/usr/share/java/jetty6/jetty6-util.jar','/usr/share/jetty/lib/jetty-util-6.1.21.jar');
	&merge_osgi_manifest($jpp,'/usr/share/java/jetty6/jetty6.jar','/usr/share/jetty/lib/jetty-6.1.21.jar');
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
');
}

sub vsystem{
    my @args=@_;
    print join(' ',@args)."\n";
    return system(@args);
}

1;
