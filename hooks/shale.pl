push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: cssparser\n");
};
__END__
install -Dm644 %{SOURCE1} .m2/repository/org/apache/shale/shale-master/2/shale-master-2.pom
