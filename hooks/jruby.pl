#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
};

1;
__END__
jruby-1.1.1:
    $jpp->get_section('build')->unshift_body('export ANT_OPTS="-Xmx256m"'."\n");
# bootstrap; can't rely on itself; subst:
#ln -sf $(build-classpath jruby)
#ln -sf $(relative %_javadir/jruby.jar %{appdir}/lib/) .
    $jpp->get_section('install')->subst_if(qr'build-classpath jruby','relative %_javadir/jruby.jar %{appdir}/lib/',qr'ln -sf');

    $jpp->get_section('package')->push_body('%add_findreq_skiplist /usr/share/jruby/lib/ruby'."\n");
    $jpp->get_section('install')->subst(qr'ln -sf \%{_libdir}/ruby','ln -sf /usr/lib/ruby');

