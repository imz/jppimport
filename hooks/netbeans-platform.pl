push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q!
# macos proxy detection code :(
#+ Requires: /usr/bin/grep
#+ Requires: /usr/sbin/scutil
%add_findreq_skiplist /usr/share/netbeans/platform*/lib/nbexec
!);

    $jpp->get_section('package','')->subst(qr'^Requires: felix','#Requires: felix');
    $jpp->get_section('package','')->subst(qr'^BuildRequires: felix','#BuildRequires: felix');
};

__END__
57a58,63
> %global lnSrcJAR() \
>   if [ -f %{1} ] ; then \
>      cp %{*} ; \
>   else \
>     echo "%{1} doesn't exist." ; exit 1 ; \
>   fi ;
73a80,85
> Source1: org.apache.felix.framework-2.0.5.jar
> Source2: org.apache.felix.main-2.0.5.jar
> Source3: org.osgi.compendium-1.4.0.jar
> Source4: org.osgi.core-1.4.0.jar
> 
> 
188,189c200,201
<   %lnSysJAR felix/org.apache.felix.framework.jar felix-2.0.3.jar
<   %lnSysJAR felix/org.apache.felix.main.jar felix-main-2.0.2.jar
---
>   %lnSrcJAR %{SOURCE1} felix-2.0.3.jar
>   %lnSrcJAR %{SOURCE2} felix-main-2.0.2.jar
192,193c204,205
<   %lnSysJAR felix/org.osgi.core.jar osgi.core-4.2.jar
<   %lnSysJAR felix/org.osgi.compendium.jar osgi.cmpn-4.2.jar
---
>   %lnSrcJAR %{SOURCE4} osgi.core-4.2.jar
>   %lnSrcJAR %{SOURCE3} osgi.cmpn-4.2.jar
235,236c247,248
<   %lnSysJAR felix/org.apache.felix.framework.jar felix-2.0.3.jar
<   %lnSysJAR felix/org.apache.felix.main.jar felix-main-2.0.2.jar
---
>   %lnSrcJAR %{SOURCE1} felix-2.0.3.jar
>   %lnSrcJAR %{SOURCE2} felix-main-2.0.2.jar
240,241c252,253
<   %lnSysJAR felix/org.osgi.compendium.jar osgi.cmpn-4.2.jar
<   %lnSysJAR felix/org.osgi.core.jar osgi.core-4.2.jar
---
>   %lnSrcJAR %{SOURCE3} osgi.cmpn-4.2.jar
>   %lnSrcJAR %{SOURCE4} osgi.core-4.2.jar
