require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # TODO eclipse-svnkit subpackage -- merge from fedora; or add repolib
    &add_missingok_config($jpp,'/etc/%{name}.conf');
}
__END__
