push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body(q!
# bugfix: Package groovy15 has broken dep on /usr/bin/startGroovy
sed -i -e 's,startGroovy,startGroovy15,g' %buildroot%_bindir/*
!);
};
