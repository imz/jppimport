require 'set_manual_no_dereference.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/chainsaw.conf');
    $jpp->get_section('build')->subst(qr'jaxp.jaxp.jar.jar', 'jaxp.jaxp.jar');
}
__END__
