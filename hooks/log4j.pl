require 'set_sasl_hook.pl';
require 'set_manual_no_dereference.pl';
require 'add_missingok_config.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/chainsaw.conf');
    $jpp->get_section('post','')->push_body(q'%update_menus
');
    $jpp->get_section('postun','')->push_body(q'%clean_menus
');
}
