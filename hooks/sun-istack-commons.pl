#!/usr/bin/perl -w

#5.0

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    # TODO: bug to report - undefined %{jafver}
    #Provides:       jaf-javadoc = 0:%{jafver}
    $jpp->get_section('package','javadoc')->subst_if(qr'Provides','#Provides',qr'jafver');

};

