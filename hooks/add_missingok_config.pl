
# example for log4j:
# /etc/chainsaw.conf (not listed in package)
# other way is
#$jpp->get_section('package','')->unshift_body('AutoReq: nosh'."\n");

# Subroutine add_missingok_config redefined at hooks/add_missingok_config.pl line 7
{ no warnings 'redefine';
  sub add_missingok_config {
    my ($jpp, $configfile,$pkg) = @_;
    $configfile ||= '/etc/%{name}.conf';
    $pkg ||='';
    $jpp->get_section('install')->push_body(q'
mkdir -p $RPM_BUILD_ROOT`dirname '.$configfile.'`
touch $RPM_BUILD_ROOT'.$configfile.'
');
    $jpp->get_section('files',$pkg)->push_body('%config(noreplace,missingok) '.$configfile."\n");
  }
}

1;
