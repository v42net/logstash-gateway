package logstash::gateway::config;
use warnings;
use strict;

use File::Path;
use Storable qw(dclone);

sub init {
    my ($this) = @_;
    my ($url, $file, $key, $fh, @cmd);

    if (! exists $this->{config}{github_config_url}) {
        die ("Missing config: github_config_url\n") 
    }
    $url = $this->{config}{github_config_url};
    $file = "/root/.git_askpass";
    if (exists $this->{secrets}{github_config_key}) {
        $key = $this->{secrets}{github_config_key};
        open($fh, ">", $file) or die("$!: $file\n");
        print $fh "#!/bin/bash\n";
        print $fh "echo $key\n";
        close($fh);
        chmod(0700, $file);
        $ENV{GIT_ASKPASS} = $file;
    }
    rmtree("/data/config");
    print "Clone '$url'\n";
    @cmd = ("git","clone",$url,"/data/config");
    system(@cmd) == 0 or die ("Git clone failed: $?\n");
    if (-r $file) {
        unlink($file);
    }
}
1;
