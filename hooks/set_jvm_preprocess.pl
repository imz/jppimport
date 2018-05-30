#!/usr/bin/perl -w

my $verbose=0;

push @PREHOOKS, 
sub {
    my ($spec, $parent) = @_;
    my @NEW_SPEC;
    my $OLDSPEC=$spec->_get_speclist();
    my $multiline_define;
    my $defined_name;
    my $defined_body=[];
    my %known_expand_define;
    foreach my $line (@$OLDSPEC) {
	if ($line=~/^\%define\s+(\w+)\(\)\s+\%\{expand:\s*$/) {
	    $multiline_define=$1;
	    #warn "found: \%define $multiline_define\n";
	} elsif ($multiline_define and $line=~/^\}\s*$/) {
	    $known_expand_define{$multiline_define}=$defined_body;
	    #warn "yanked: \%define $multiline_define\n";
	    $multiline_define=undef;
	    $defined_body=[];
	} elsif ($multiline_define) {
	    # %{jvmjdk -- %{?1}}
	    $line=~s/\s+--\s+\%\{\?1\}//g;
	    # Requires: %{name}-headless%{?1}%{?_isa}
	    $line=~s/\%\{\?1\}//g;
	    push @$defined_body, $line;

	# %{files_jre -- %{debug_suffix_unquoted}}
	# %{files_jre_headless %{nil}}
	} elsif ($line=~/^\%\{(\w+)\s+(?:--\s+)?(\S+)/) {
	    my $name=$1;
	    my $arg=$2;
	    if (not $known_expand_define{$name}) {
		push @NEW_SPEC, $line;
	    } elsif ($arg =~ /\%\{nil\}/ and $name =~/^(?:files|java)/) {
		push @NEW_SPEC, @{$known_expand_define{$name}};
	    } else {
		# drop it
		warn "dropped: \%$name $arg\n" if $verbose;
	    }
	} else {
	    push @NEW_SPEC, $line;
	}
    }
    $spec->_set_speclist(\@NEW_SPEC);


#%define sdkdir()        %{expand:%{uniquesuffix -- %{?1}}}
#%define jrelnk()        %{expand:jre-%{javaver}-%{origin}-%{version}-%{release}.%{_arch}%{?1}}
#%define jredir()        %{expand:%{sdkdir -- %{?1}}/jre}
#%define sdkbindir()     %{expand:%{_jvmdir}/%{sdkdir -- %{?1}}/bin}
#%define jrebindir()     %{expand:%{_jvmdir}/%{jredir -- %{?1}}/bin}
    $spec->applied_off();
    foreach my $sec ($spec->get_sections()) {
	$sec->map_body(
	    sub {
		s,\%\{(buildoutputdir|uniquejavadocdir|uniquesuffix|sdkdir|jrelnk|jredir|sdkbindir|jrebindir|jvmjardir)\s+--\s+(?:\%\{\?1\}|\$suffix)\},%{$1},g;
	    });

    }
    $spec->applied_on();
    $spec->main_section->map_body(
	sub {
	    s,(?:\s+--\s+)?\%\{\?1\},, if s,^(\%(?:global|define)\s+(?:buildoutputdir|uniquejavadocdir|uniquesuffix|sdkdir|jrelnk|jredir|sdkbindir|jrebindir|jvmjardir))\(\)\s+\%\{expand:(.+)\}\s*$,$1 $2\n,;
	}
	);


};

__END__
