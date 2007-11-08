require 'set_sasl_hook.pl';
require 'set_manual_no_dereference.pl';
require 'set_update_menus.pl';
require 'add_missingok_config.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/chainsaw.conf');
}
