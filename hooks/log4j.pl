require 'add_missingok_config.pl';
require 'set_skip_usr_bin_run.pl';
require 'set_osgi.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    &add_missingok_config($spec,'/etc/chainsaw.conf');
}
__END__
