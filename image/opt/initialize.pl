#!/usr/bin/perl
package logstash::gateway;
use warnings;
use strict;

use Data::Dumper;
use File::Path;

require "/opt/init_config.pm";
require "/opt/init_frontend.pm";
require "/opt/init_kafka.pm";
require "/opt/init_backend.pm";

my $this = bless({}, __PACKAGE__);
print "\n\n\n";
$this->init();
print "\n\n\n";

sub init {
    my ($this) = @_;
    my (@dirs, @user);
    $this->{hostname} = `hostname`;
    $this->{hostname} =~s/\s+//g;
    $this->{basename} = ($this->{hostname}=~/^(.*?)\-?\d?$/)[0];
    $this->{node} = index("123",($this->{hostname}=~/(.)$/)[0])+1;
    $this->{config} = $this->load_cfg("/config.cfg");
    $this->{secrets} = $this->load_cfg("/run/secrets/secrets.cfg");

    @dirs = ("/data/log","/data/log/backend","/data/log/frontend","/data/log/kafka");
    mkpath(\@dirs);
    @user = getpwnam("nobody");
    chown($user[2],$user[3], @dirs);
    chmod(02755, @dirs);

    logstash::gateway::config::init($this);
    logstash::gateway::frontend::init($this);
    logstash::gateway::kafka::init($this);
    logstash::gateway::backend::init($this);
}
sub load_cfg {
    my ($this, $file) = @_;
    my ($fh, @lines, $cfg, $line, @line);
    open($fh, "<", $file) or die("$!: $file\n");
    @lines = <$fh>;
    close($fh);
    $cfg = {};
    foreach $line (@lines) {
        $line=~ s/^\s+|\s+$//g;
        @line = split(/\s*=\s*/, $line, 2);
        next if (($#line != 1) || ($line[0] =~ /^#/));
        $cfg->{lc($line[0])} = $line[1];
    }
    return $cfg;
}
sub save_cfg {
    my ($this, $config, $file, $mode) = @_;
    my ($fh, $key, $value);
    open($fh, ">", $file) or die("$!: $file\n");
    foreach $key (sort keys %$config) {
        $value = $config->{$key};
        print $fh "$key=$value\n";
    }
    close($fh);
    if (defined $mode) {
        chmod ($mode, $file);
    }
}


