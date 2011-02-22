#!/usr/bin/perl -w


push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # 6.0
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-resources maven2-plugin-plugin'."\n");
    $jpp->get_section('install')->push_body(q!
%__subst 's,java_cup,java-cup,' $RPM_BUILD_ROOT/%_bindir/jflex
!);
    
}

__END__
5.0
    $jpp->get_section('package','')->subst_if(qr'java_cup','java-cup',qr'Requires:');
