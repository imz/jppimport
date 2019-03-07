#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    my $sec=$spec->get_section('pretrans','javadoc');
    if (not $sec or not $sec->get_flag('-p')) {
	warn "WARNING: set_javadoc_namelink_check: javadoc lua not found!";
	return;
    }
    $sec->delete;
    $spec->get_section('install')->push_body(q!
# set_javadoc_namelink_check
%pre javadoc
path = "%{_javadocdir}/%{name}"
if [ -L $path ]; then
  rm -f $path
fi ||:

!."\n");
};

__END__
