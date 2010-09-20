#!/usr/bin/perl -w

#require 'set_without_maven.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

1;
__END__
TODO:
36a37
> %define _with_maven 1
59,60c60,62
< BuildRequires: maven
< BuildRequires: maven-plugin-modello
---
> BuildRequires: maven2-plugins
> BuildRequires: modello-maven-plugin
> BuildRequires: jetty6-core maven2-default-skin
119c121,122
<         install javadoc:javadoc site
---
>         install javadoc:javadoc 
> #site
215,217c218,220
< rm -rf target/site/apidocs 
< install -d -m 755 $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}
< cp -pr target/site/* $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}
---
> #rm -rf target/site/apidocs 
> #install -d -m 755 $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}
> #cp -pr target/site/* $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}
230,231c233,234
< %files manual
< %doc %{_docdir}/%{name}-%{version}
---
> #%files manual
> #%doc %{_docdir}/%{name}-%{version}



__DATA__
# 5.0
    # fix when without maven1 (included in 2jpp)
    #$jpp->get_section('build')->subst(qr'maven-modello-plugin','maven-plugins/maven-modello-plugin');
