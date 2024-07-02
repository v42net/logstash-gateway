package logstash::gateway::kafka;
use warnings;
use strict;

use File::Path;
use Storable qw(dclone);

sub init { # initialize kafka
    my ($this) = @_;
    my ($kafka, $config);
    $kafka = bless(dclone($this), __PACKAGE__);
    $config = $this->load_cfg("/opt/kafka/config/kraft/server.properties");
    if ($kafka->{node} == 0) { 
        print "Configuring a single-node kafka cluster\n";
        $kafka->configure_1($config); # single-node
    }
    else { 
        print "Configuring a three-node kafka cluster\n";
        $kafka->configure_3($config); # three-node
    }
    delete($config->{"advertised.listeners"});
    $config->{"log.dirs"} = "/data/kafka/logs";
    mkpath("/data/kafka/logs");
    $this->save_cfg($config, "/data/kafka/server.properties");
    $kafka->format();
    $kafka->check($this);
}
sub configure_1 { # generate a single-node kafka configuration
    my ($kafka, $config) = @_;
    my ($name);
    $name = $kafka->{hostname};
    $kafka->{"node.id"} = 1;
    $config->{"node.id"} = 1;
    $config->{"controller.quorum.voters"} = "1\@$name:9093";
    $config->{"listeners"} = "PLAINTEXT://$name:9092,CONTROLLER://$name:9093";
    $config->{"num.partitions"} = 1;
    $config->{"offsets.topic.replication.factor"} = 1;
    $config->{"transaction.state.log.replication.factor"} = 1;
}
sub configure_3 { # generate a three-node kafka configuration
    my ($kafka, $config) = @_;
    my ($name, $node, $n);
    $name = $kafka->{basename};
    $node = $kafka->{node};
    $kafka->{"node.id"} = $node;
    $config->{"node.id"} = $node;
    $config->{"controller.quorum.voters"} = "$node\@$name-$node:9093";
    $config->{"listeners"} = "PLAINTEXT://$name-$node:9092,CONTROLLER://$name-$node:9093";
    foreach $n (1, 2, 3) {
        next if ($n == $node);
        $config->{"controller.quorum.voters"} .= ",$n\@$name-$n:9093";
        $config->{"listeners"} .= ",PLAINTEXT://$name-$n:9092,CONTROLLER://$name-$n:9093";
    }
    $config->{"num.partitions"} = 3;
    $config->{"offsets.topic.replication.factor"} = 2;
    $config->{"transaction.state.log.replication.factor"} = 2;
}
sub format { # format kafka storage
    my ($kafka) = @_;
    my ($id, @cmd);
    if (! exists $kafka->{secrets}{kafka_cluster_id}) {
        die ("Missing secret: kafka_cluster_id\n") 
    }
    $id = $kafka->{secrets}{kafka_cluster_id};
    return if (-r "/data/kafka/logs/meta.properties");
    @cmd = ("/opt/kafka/bin/kafka-storage.sh","format","-t",$id,"-c","/data/kafka/server.properties");
    system(@cmd) == 0 or die ("Kafka format failed: $?\n");
}
sub check { # check the kafka configuration
    my ($kafka, $this) = @_;
    my ($metadata);
    $metadata = $this->load_cfg("/data/kafka/logs/meta.properties");
    if ($metadata->{"node.id"} != $kafka->{"node.id"}) {
        die("Kafka node.id mismatch\n");
    }
    if ($metadata->{"cluster.id"} ne $kafka->{secrets}{kafka_cluster_id}) {
        die("Kafka cluster.id mismatch\n");
    }
}
1;
