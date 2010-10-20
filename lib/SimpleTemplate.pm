package SimpleTemplate;

use strict;
use warnings;

use Data::Dumper;
use Config::IniFiles;

our $VERSION = 1;

use Template;
use Cpanel::Config::userdata::Load;
use Cpanel::Logger;

##
# @param user string name of user that owns domain
# @param domain domain name being modified
# @param domain_type string parked, addon, sub, main
# 
# For type 'parked' the domain name will be the main domain

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
    $self->{'domain_type'} = $domain_type;

    # TODO define place to put the config file
    tie my %config, 'Config::IniFiles', (-file => '/etc/simpletemplate/simple_template.conf') ;
    $self->{'config'} = \%config;

    bless $self, $class;
    return $self;
}

sub _load_userdata{
    my ( $self, $domain ) = @_;

    $domain ||= $self->{'domain'};
    $self->{'vhost'} = Cpanel::Config::userdata::Load::load_userdata( $self->{'user'}, $domain );

    if( ! keys %{ $self->{'vhost'} } ){
        Cpanel::Logger::logger(
            {
                'message' => 'Unable to load userdata. Requested user: '. $self->{'user'}.' domain: '. $self->{'domain'},
                'level' => 'warn',
                'output' => 0,
                'service' => 'simpletemplate',
            }
        );
    }
    else{
        return 1;
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
