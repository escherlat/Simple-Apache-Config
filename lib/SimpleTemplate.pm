package SimpleTemplate;

use strict;
use warnings;

use Data::Dumper;
use Config::IniFiles;

our $VERSION = 1;

use lib '/usr/local/cpanel';

use Template;
use Cpanel::Config::userdata::Load;

##
# @param user string name of user that owns domain
# @param domain domain name being modified
# @param domain_type string parked, addon, sub, primary
# 
# For type 'parked' the domain name will be the primary domain

sub new{
    my ( $class, $user, $domain, $domain_type ) = @_;

    if( ! $user ){
	die "No user provided!\n";
    }

    if( ! $domain ){
	die "No domain provided!\n";
    }

    $domain_type ||= 'main';

    my $self = ();
    $self->{'user'} = $user;
    $self->{'domain'} = $domain;

    # TODO define place to put the config file
    tie my %config, 'Config::IniFiles', (-file => 'config/simple_template.conf') ;
    $self->{'config'} = \%config;

    $self->{'vhost'} = Cpanel::Config::userdata::Load::load_userdata( $user, $domain );

    if( ! keys %{ $self->{'vhost'} } ){
	die "Unable to load userdata!\n";
    }
    else{
	bless $self, $class;
	return $self;
    }
}

sub _post_update_processing{
    my ( $self, $action ) = @_;
    if( exists $self->{'config'}->{'template_engine'}->{'system_type'} ){
	if( lc($self->{'config'}->{'template_engine'}->{'system_type'}) eq 'debian' ){
	    eval{
		require SimpleTemplate::System::Debian;
	    };
	    if( ! $@ ){
		SimpleTemplate::System::Debian::update_config( $action, $self->{'domain'} );
	    }
	}
    }
}

1;
