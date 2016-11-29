#!/usr/bin/perl -w

require 'set_osgi.pl';
#require 'set_add_fc_osgi_manifest.pl';

__END__

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
# already in spec
#    $spec->get_section('package','')->push_body('Provides: jakarta-%{short_name} = %{version}'."\n");
#    $spec->get_section('package','')->push_body('Provides: %{short_name} = %{version}'."\n");
    $spec->get_section('install')->push_body('# jakarta compat
ln -s %{short_name}.jar %buildroot%_javadir/jakarta-%{short_name}.jar
#ln -s %{short_name}.jar %buildroot%_javadir/apache-%{short_name}.jar
'."\n");
    #$spec->get_section('files','')->push_body('%exclude %_javadir/repository.jboss.com'."\n");
}
