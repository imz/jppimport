#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->add_patch('hadoop-2.4.1-alt-sh-syntax.patch',STRIP=>0);
    $spec->get_section('package','')->unshift_body('BuildRequires: avro-maven-plugin'."\n");
    $spec->get_section('package','')->unshift_body('BuildRequires: zlib-devel'."\n");
    $spec->get_section('package','')->unshift_body('%define _libexecdir %_prefix/libexec'."\n");
    $spec->get_section('files','yarn-security')->subst_body_if(qr'6050,root,yarn','6010,root,yarn',qr'/container-executor');
    # uncomment if stll needed -- used for -2.4.1-alt1_14
    $spec->get_section('prep')->push_body(q!%pom_add_dep org.fusesource.leveldbjni:leveldbjni hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-applicationhistoryservice!."\n");
    my $sec=$spec->get_section('pretrans','hdfs');
    if (not $sec or not $sec->get_flag('-p')) {
	die "WARNING: lua pretrans not found!";
    } else {
	$sec->delete;
	$spec->get_section('pre','hdfs')->push_body(q!
# from pretrans
path = "%{_datadir}/%{name}/hdfs/webapps"
if [ -L $path ]; then
  rm -f $path
fi ||:

!."\n");
    }
    # don't do: 2 post's
    #$spec->get_section('posttrans','hdfs')->set_type('post');
    $sec=$spec->get_section('posttrans','hdfs');
    my @body1=@{$sec->get_bodyref};
    shift @body1;
    my $sec2=$spec->get_section('post','hdfs');
    $sec2->push_body (@body1);
    $sec->delete;

};

__END__
