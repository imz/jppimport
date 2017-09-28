#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;

    # looks like common bug
#(cd $RPM_BUILD_ROOT%{_javadir} && for jar in *-%{version}*; do ln -sf ${jar} `echo $jar| sed "s|apache-|jakarta-|g"`; done)
    $spec->get_section('install')->subst_body_if(qr'for jar in \*-\%{version}\*;','for jar in apache-*-%{version}*;',qr's\|apache-\|jakarta-\|');
#(cd $RPM_BUILD_ROOT%{_javadir} && for jar in *-%{version}*; do ln -sf ${jar} `echo $jar| sed "s|apache-||g"`; done)
    $spec->get_section('install')->subst_body_if(qr'for jar in \*-\%{version}\*;','for jar in apache-*-%{version}*;',qr's\|apache-\|\|');

}

__END__
