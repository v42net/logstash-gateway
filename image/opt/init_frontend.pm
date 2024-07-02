package logstash::gateway::frontend;
use warnings;
use strict;

use Storable qw(dclone);

sub init {
    my ($this) = @_;
    my ($frontend);
    $frontend = bless(dclone($this), __PACKAGE__);
}
1;
