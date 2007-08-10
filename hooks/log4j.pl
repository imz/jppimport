require 'set_sasl_hook.pl';
require 'set_manual_no_dereference.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    # /etc/chainsaw.conf (not listed in package)
    #$jpp->get_section('package','')->unshift_body('AutoReq: nosh'."\n");
    $jpp->get_section('install','')->push_body(q'
mkdir -p $RPM_BUILD_ROOT/etc
touch $RPM_BUILD_ROOT/etc/chainsaw.conf
');
    $jpp->get_section('files','')->push_body('%config(noreplace,missingok) /etc/chainsaw.conf'."\n");
}
