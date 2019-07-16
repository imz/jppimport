#!/usr/bin/perl -w

#require 'set_bin_755.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
#    $spec->get_section('pretrans','-p <lua>')->delete;

    # arch dependent symlink to /usr/lib/java/jansi-native/jansi-linux32/64.jar :(
    $spec->get_section('install')->push_body(q!
pushd %buildroot%{_datadir}/%{name}/lib
[ -e jansi-linux.jar ] || exit 1
rm jansi-linux.jar
ln -s /usr/lib/java/jansi-native/jansi-linux.jar .
popd!."\n"."\n");
};

__END__
