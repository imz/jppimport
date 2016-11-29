#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    #$spec->add_patch('',STRIP=>1);
    $spec->get_section('package','')->push_body('%define short_name commons-fileupload
Provides: %{short_name} = %{version}'."\n");
    #Obsoletes:        jakarta-%{short_name} < 1:1.2.1-2
    $spec->get_section('package','')->subst_body_if(qr'1.2.1-2','1.2.2',qr'Obsoletes:');
    $spec->get_section('package','')->push_body(q!Conflicts:	jakarta-%{short_name} < 1:%version!."\n");
};

__END__
