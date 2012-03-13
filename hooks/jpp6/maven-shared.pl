
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # remove when deprecated!
    #maven-shared-8-0.p8.8jpp6.src.rpm 
    $jpp->get_section('prep')->unshift_body('
if grep plexus-containers-container-default %_sourcedir/maven-shared-ant-pom.patch; then
    # bugfix
sed -i -e s:plexus-containers-container-default:containers-container-default: %_sourcedir/maven-shared-ant-pom.patch
else
    echo "the hook hack is deprecated; remove"
fi
');
};

__END__
