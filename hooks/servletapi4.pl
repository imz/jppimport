#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
# todo: make an extension
    $jpp->get_section('install')->push_body('
cat >>$RPM_BUILD_ROOT/%_altdir/servletapi_%{name}<<EOF
%{_javadir}/servletapi.jar	%{_javadir}/%{name}-%{version}.jar	20300
EOF
');
    $jpp->get_section('files')->push_body('%_altdir/servletapi_*'."\n");

    # they create broken symlink
    $jpp->del_section('post','javadoc');
    $jpp->del_section('postun','javadoc');
}
