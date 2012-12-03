#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # sisyphus_check
    $jpp->get_section('files','')->subst_body(qr'^\%doc','%attr(0755,root,root) %doc');
    $jpp->get_section('files','')->push_body('%attr(0755,root,root) %dir %{bindir}'."\n");
    $jpp->get_section('files','')->subst_body(qr'^\%{bindir}/','%attr(0644,root,root) %{bindir}/');
    $jpp->get_section('files','')->subst_body(qr'^\%dir %{apphomedir}','%attr(0755,root,root) %dir %{apphomedir}');
};

__END__