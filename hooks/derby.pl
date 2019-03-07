require 'add_missingok_config.pl';
require 'set_skip_usr_bin_run.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    # note; usually fedora import
    &add_missingok_config($spec,'/etc/%{name}.conf');
}
__END__
