#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('prep')->push_body(q!sed -i -e s,/usr/bin/ln,/bin/ln,g dogtag/common-ui/CMakeLists.txt!."\n");
    $spec->get_section('files','-n dogtag-pki-server-theme')->exclude_body(qr'^\%dir \%\{_datadir\}/pki\s*$');
    $spec->get_section('files','-n dogtag-pki-server-theme')->push_body('%dir %{_datadir}/pki/server/webapps/pki
%dir %{_datadir}/pki/server/webapps
%dir %{_datadir}/pki/server'."\n");
};

__END__
