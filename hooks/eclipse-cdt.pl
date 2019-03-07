require 'set_add_java_bin.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
};
__END__
    # Deprecated?
    # tmp hack to satisfy osgi req
    $spec->get_section('package','')->unshift_body('
Provides: osgi(org.eclipse.cdt.core.tests) = 7.0.0
%filter_from_requires s/osgi(javax.servlet.*//
#Provides: osgi(javax.servlet) = 2.5.0
'."\n");
#osgi(javax.servlet) >= 2.5.0
