#require 'set_without_sf_plugins.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

__END__
    # for newer version:
    # TODO: build an old repolib version and a new one w/o repolib.


#file /usr/share/java/saxpath.jar conflicts between attempted installs of jaxen-1.1.1-alt1_1jpp5 and saxpath-1.0-alt1_3jpp5
#hsh-install: Packages installation failed.
    # implicit conflict with saxpath;
    # TODO: make an alternative?
    $jpp->get_section('install')->exclude(qr'saxpath');

