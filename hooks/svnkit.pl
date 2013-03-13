require 'add_missingok_config.pl';
# for opends
require 'set_target_15.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # note; usually fedora import
    &add_missingok_config($jpp,'/etc/%{name}.conf');
}
__END__
