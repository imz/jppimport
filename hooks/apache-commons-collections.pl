#!/usr/bin/perl -w

require 'set_apache_obsoletes_epoch1.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;

}

__END__
    $spec->get_section('prep')->push_body(q!!."\n");
#Provides:       jakarta-%{short_name} = %{epoch}:%{version}-%{release}
#Obsoletes:      jakarta-%{short_name} < %{epoch}:%{version}-%{release}
Provides:       %{short_name} = %{epoch}:%{version}-%{release}
Obsoletes:      %{short_name} < %{epoch}:%{version}-%{release}
