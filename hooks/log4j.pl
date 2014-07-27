require 'add_missingok_config.pl';
require 'set_osgi.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/chainsaw.conf');
}
__END__
