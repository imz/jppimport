#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
};

1;

__END__
build:
export ANT_OPTS="-Xmx256m"

# bootstrap; can't rely on itself; subst:
#ln -sf $(build-classpath jruby)
ln -sf $(relative %_javadir/jruby.jar %{appdir}/lib/) .
