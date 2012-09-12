#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('package','')->push_body('');

    $jpp->get_section('files','')->push_body(q!
%_altdir/FastInfoset_glassfish-fastinfoset
%exclude %{_javadir}*/FastInfoset.jar
!."\n");

    $jpp->get_section('install')->push_body(q!
install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/FastInfoset_glassfish-fastinfoset<<EOF
%{_javadir}/FastInfoset.jar	%{_javadir}/%name.jar	300
EOF
!."\n");
};

__END__
