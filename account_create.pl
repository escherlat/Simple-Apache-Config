#!/usr/bin/perl

BEGIN{
    if( $< != 0 ){
	print "This must run as root\n";
	exit 1;
    }
}

use strict;
use warnings;
use Data::Dumper;

our $VERSION = 1;

use lib '/home/kpower/Projects/simple_apache_template/lib';

use SimpleTemplate::Add;
use SimpleTemplate::Remove;

my $st = SimpleTemplate::Add->new( 'kpowerme', 'kpower.me', 'parked' );

$st->update_config();
