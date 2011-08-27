#!/usr/bin/perl -w
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('build')->unshift_body2_after('ln -sf $(build-classpath bsf)'."\n",qr'pushd lib');
    &add_missingok_config($jpp, '/etc/%{name}.conf');
#313c313
#< sed -i 's/@VERSION@/%{version}.%{reltag}-brew/g' %{buildroot}%{repodir}/component-info.xml
#---
#> sed -i 's/@VERSION@/%{version}-brew/g' %{buildroot}%{repodir}/component-info.xml
    $jpp->get_section('install')->subst_if(qr'{version}.\%{reltag}-brew','{version}-brew',qr'component-info.xml');
};

__END__
