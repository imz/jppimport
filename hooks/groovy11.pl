push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body(q!
# bugfix: Package groovy11 has broken dep on /usr/bin/startGroovy
sed -i -e 's,startGroovy,startGroovy11,g' %buildroot%_bindir/*
!);
    $jpp->get_section('install')->subst_body(qr'^ln -sf %{_javadir}/groovy',
					     'ln -sf %{_javadir}/%name');
};
