#!/usr/bin/perl -w

require '../jppimport.1';

my $sec=RPM::SpecSection->new(
	TYPE=> 'package',
	PACKAGE=> '',
	BODY=>[" dfgg \n","\n","	\%ifarch ass\n"," \%if_with\n","\%if\n"],
);

$sec->push_body("111\n");

print $sec->get_body()->[2];
