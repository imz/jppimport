push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    die "do it manuially!";
    $jpp->get_section('install')->push_body(q!
# bugfix: Package groovy17 has broken dep on /usr/bin/startGroovy
#sed -i -e 's,startGroovy,startGroovy17,g' %buildroot%_datadir/%name-%version/*
!);
};
