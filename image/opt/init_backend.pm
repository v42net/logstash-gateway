package logstash::gateway::backend;
use warnings;
use strict;

use File::Path;
use Storable qw(dclone);

sub init {
    my ($this) = @_;
    my ($backend, @dirs, @user);
    $backend = bless(dclone($this), __PACKAGE__);
    
    @dirs = ("/data/backend/data", "/data/backend/logs");
    mkpath(\@dirs);
    chmod(0755, "/data/backend", @dirs);
    @user = getpwnam("backend");
    chown($user[2],$user[3], @dirs);
}
1;
