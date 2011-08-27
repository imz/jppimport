require 'set_manual_no_dereference.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/chainsaw.conf');
    $jpp->get_section('build')->subst(qr'jaxp.jaxp.jar.jar', 'jaxp.jaxp.jar');
    $jpp->get_section('install')->unshift_body_after(qr'__sed.+repodir.+/component-info.xml',
q!sed -i "s/1.2.14-brew/%{version}-brew/g" %{buildroot}%{repodir}/component-info.xml
!);
}
__END__
