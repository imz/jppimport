push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body(q!
# bugfix: Package groovy16 has broken dep on /usr/bin/startGroovy
sed -i -e 's,startGroovy,startGroovy16,g' %buildroot%_bindir/*
!);
};
