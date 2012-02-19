#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->add_patch('',STRIP=>1);

# TODO
#Conflicts:        java-1.6.0-openjdk <= 1:1.6.0.0-47                            


    $jpp->get_section('files','')->subst(qr'bindir}/jvisualvm','bindir}/jvisualvm-openjdk');
#    $jpp->get_section('package','')->subst_if(qr'','',qr'Requires:');
#    $jpp->get_section('package','')->unshift_body('BuildRequires: '."\n");
    $jpp->get_section('install')->push_body(q!
##################################################
# --- alt linux specific, shared with openjdk ---#
##################################################
# alternatives
mv %buildroot%{_bindir}/jvisualvm %buildroot%{_bindir}/jvisualvm-openjdk
%__cat <<EOF >>%buildroot%_altdir/%name
%_bindir/jvisualvm	%_bindir/jvisualvm-openjdk	16000
EOF
##################################################
# - END alt linux specific, shared with openjdk -#
##################################################
# todo: MAKE A patch
%define javaver 1.7.0 
sed -i -e 's,Exec=/usr/bin/jvisualvm,Exec=/usr/bin/jvisualvm-openjdk,' %buildroot%_desktopdir/visualvm.desktop
sed -i -e 's,Icon=java,Icon=visualvm,' %buildroot%_desktopdir/visualvm.desktop
sed -i -e 's,Categories=.*,Categories=Development;Profiling;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-openjdk;,' %buildroot%_desktopdir/visualvm.desktop

!."\n");
};

__END__
[Desktop Entry]
Name=OpenJDK VisualVM
Comment=Integrates commandline JDK tools and profiling capabilites.
Exec=/usr/bin/jvisualvm
Icon=java
Terminal=false
Type=Application
Categories=Development;Java;



    $jpp->get_section('install')->push_body(q!
install -d -m 755 $RPM_BUILD_ROOT%{_datadir}/applications
if [ -e $RPM_BUILD_ROOT%{_jvmdir}/%{sdkdir}/bin/jvisualvm ]; then
  cat >> $RPM_BUILD_ROOT%{_datadir}/applications/%{name}-jvisualvm.desktop << EOF
[Desktop Entry]
Name=Java VisualVM (%{name})
Comment=Java Virtual Machine Monitoring, Troubleshooting, and Profiling Tool
Exec=jvisualvm-openjdk
Icon=%{name}
Terminal=false
Type=Application
Categories=Development;Profiling;Java;X-ALTLinux-Java;X-ALTLinux-Java-%javaver-%{origin};
EOF
fi
!);

__END__

    # deprecated
    unless ('old java w/visualvm') {
    $jpp->get_section('install')->push_body(q!
# dirty, dirty hack :(
pushd %buildroot%{_jvmdir}/%{sdkdir}/lib/visualvm/profiler3/lib/deployed
rm -rf jdk1?/{mac,solaris-amd64,solaris-i386,solaris-sparc,solaris-sparcv9,windows,windows-amd64}
%ifarch %{ix86}
rm -rf jdk1?/linux-amd64
%endif
%ifarch x86_64
rm -rf jdk1?/linux
%endif
popd
!);

