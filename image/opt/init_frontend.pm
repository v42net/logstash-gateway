package logstash::gateway::frontend;
use warnings;
use strict;

use File::Path;
use Storable qw(dclone);

sub init {
    my ($this) = @_;
    my ($frontend, @dirs, @user);
    $frontend = bless(dclone($this), __PACKAGE__);

    @dirs = ("/data/frontend/data", "/data/frontend/logs");
    mkpath(\@dirs);
    chmod(0755, "/data/frontend", @dirs);
    @user = getpwnam("frontend");
    chown($user[2],$user[3], @dirs);
}
1;
