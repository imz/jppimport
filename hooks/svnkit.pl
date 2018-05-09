require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    # note; usually fedora import
    &add_missingok_config($spec,'/etc/%{name}.conf');
}
__END__
