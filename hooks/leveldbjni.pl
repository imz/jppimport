#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: gcc-c++'."\n");
    $spec->get_section('prep')->push_body(q!# e2k support: force autogen
%pom_xpath_inject "pom:plugin[pom:artifactId='maven-hawtjni-plugin']/pom:configuration" "<skipAutogen>false</skipAutogen>" %{name}-linux64
rm -f leveldbjni/src/main/native-package/configure!."\n");
};

__END__
