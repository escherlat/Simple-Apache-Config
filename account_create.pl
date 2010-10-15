#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

our $VERSION = 1;

use lib '/usr/local/cpanel';

use Template;
use Cpanel::Config::userdata::Load;

my $template_dir = '/root/simple_config_template';
my $user = 'kpowerme';
my $domain = 'kpower.me';

my $userdata->{'vhost'} = Cpanel::Config::userdata::Load::load_userdata( $user, $domain );

my $template = Template->new(
    INCLUDE_PATH => $template_dir,
    );

$template->process( 'simple_template.tpl', $userdata ) || print Dumper $template->error();

