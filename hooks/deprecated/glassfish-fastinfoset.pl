#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    #$spec->get_section('package','')->push_body('');

    $spec->get_section('files','')->push_body(q!
%_altdir/FastInfoset_glassfish-fastinfoset
%exclude %{_javadir}*/FastInfoset.jar
!."\n");

    $spec->get_section('install')->push_body(q!
install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/FastInfoset_glassfish-fastinfoset<<EOF
%{_javadir}/FastInfoset.jar	%{_javadir}/%name.jar	300
EOF
!."\n");
};

__END__
