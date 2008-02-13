#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->unshift_body('export ANT_OPTS="-Xmx256m"'."\n");
# bootstrap; can't rely on itself; subst:
#ln -sf $(build-classpath jruby)
#ln -sf $(relative %_javadir/jruby.jar %{appdir}/lib/) .
    $jpp->get_section('install')->subst_if(qr'build-classpath jruby','relative %_javadir/jruby.jar %{appdir}/lib/',qr'ln -sf');
};

1;
