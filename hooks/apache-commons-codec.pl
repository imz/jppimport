#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
# already in spec
#    $jpp->get_section('package','')->push_body('Provides: jakarta-%{short_name} = %{version}'."\n");
#    $jpp->get_section('package','')->push_body('Provides: %{short_name} = %{version}'."\n");
    $jpp->get_section('install')->push_body('# jakarta compat
ln -s %{short_name}.jar %buildroot%_javadir/jakarta-%{short_name}.jar
ln -s %{short_name}.jar %buildroot%_javadir/apache-%{short_name}.jar
'."\n");
    #$jpp->get_section('files','')->push_body('%exclude %_javadir/repository.jboss.com'."\n");
}
__END__
