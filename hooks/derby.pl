require 'add_missingok_config.pl';
require 'set_skip_usr_bin_run.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # note; usually fedora import
    &add_missingok_config($jpp,'/etc/%{name}.conf');
}
__END__
