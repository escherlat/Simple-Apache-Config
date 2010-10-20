package SimpleTemplate::Add;

use strict;
use warnings;

use base qw(SimpleTemplate);

use Cpanel::Logger;

our $VERSION = 1;

##
# This module is responsible for Adding a new configuration
sub new{
    my( $class ) = shift;
    return $class->SUPER::new( @_ );
}

sub update_config{
    my ( $self ) = @_;

    if( $self->_load_userdata() ){
        my %vhost;
        $vhost{'vhost'} = $self->{'vhost'};
        if( $self->{'domain_type'} eq 'addon' ){
            eval {
                require SimpleTemplate::AddonDomain;
            };
            if( ! $@ ){
                my $addon_domain = SimpleTemplate::AddonDomain::get_actual_domain( $self->{'user'}, $self->{'domain'} );
                if( $addon_domain ){
                    $vhost{'vhost'}{'servername'} = $addon_domain;
                    $vhost{'vhost'}{'serveralias'} = 'www.'.$addon_domain;
                    $vhost{'vhost'}{'serveradmin'} =~ s/$self->{'domain'}/$addon_domain/;
                    $self->{'domain'} = $addon_domain;
                }
            }
            else{
                Cpanel::Logger::logger(
                    {
                        "message" => "Unable to load SimpleTemplate::AddonDomain: $@",
                        "level" => "warn",
                        "backtrace" => 0,
                        "service" => "simpletemplate::add",
                        "output" => 0,
                    }
                );
            }
        }
        
        my $template = Template->new(
            INCLUDE_PATH => $self->{'config'}->{'template_engine'}->{'template_directory'}.'/'. $self->{'config'}->{'template_engine'}->{'service_type'},
            OUTPUT_PATH => $self->{'config'}->{'service_config'}->{'service_config_directory'},
        );
        
        # Get file name
        my $file_name = $self->{'domain'};
        
        if ( $self->{'config'}->{'service_config'}->{'config_style'} =~ m/split/i ){
            # Write file
            $template->process( 'simple_template.tpl', \%vhost, $self->{'domain'} ) || print $template->error();
        }
        else{
            # monolithic not implemented yet
        }
        $self->_post_update_processing( 'add' );
        return 1;
    }
    else{
        Cpanel::Logger::logger(
            {
                'message' => 'Failed to load userdata to add the virtual host config',
                'level' => 'warn',
                'output' => 0,
                'service' => 'simpletemplate::add',
            }
        );
    }
}

1;
