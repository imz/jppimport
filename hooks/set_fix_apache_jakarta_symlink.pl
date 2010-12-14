#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # looks like common bug
#(cd $RPM_BUILD_ROOT%{_javadir} && for jar in *-%{version}*; do ln -sf ${jar} `echo $jar| sed "s|apache-|jakarta-|g"`; done)
    $jpp->get_section('install')->subst_if(qr'for jar in \*-\%{version}\*;','for jar in apache-*-%{version}*;',qr's\|apache-\|jakarta-\|');

}

__END__
