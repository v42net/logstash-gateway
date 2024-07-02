package logstash::gateway::backend;
use warnings;
use strict;

use Storable qw(dclone);

sub init {
    my ($this) = @_;
    $this = bless(dclone($this), __PACKAGE__);

}
1;
