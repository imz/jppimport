#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
# todo: make an extension
    $spec->get_section('install')->push_body('
cat >>$RPM_BUILD_ROOT/%_altdir/servletapi_%{name}<<EOF
%{_javadir}/servletapi.jar	%{_javadir}/%{name}-%{version}.jar	20300
EOF
');
    $spec->get_section('files')->push_body('%_altdir/servletapi_*'."\n");

    # they create broken symlink
    $spec->del_section('post','javadoc');
    $spec->del_section('postun','javadoc');
}
