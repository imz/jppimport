#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    my $mainsec=$spec->main_section;

    # 1core build (16core build is out of memory). Disable for faster local builds on ohmu
    # export NUM_PROC=%(/usr/bin/getconf _NPROCESSORS_ONLN 2> /dev/null || :)
    $spec->get_section('build')->subst_body_if(qr'^export\s+NUM_PROC=','#export NUM_PROC=','_NPROCESSORS_ONLN');
};

__END__
