#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('prep')->push_body(q!sed -i -e s,/bin/bash,/bin/bash4, common/codegen.bash!."\n");
    $spec->get_section('package','')->unshift_body('BuildRequires: bash4'."\n");
};

__END__
