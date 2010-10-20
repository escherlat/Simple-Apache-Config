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

    my %vhost;
    $vhost{'vhost'} = '';
    if( $self->{'domain_type'} eq 'addon' ){
        eval {
            require SimpleTemplate::AddonDomain;
        };
        if( ! $@ ){
            my $sub_domain = SimpleTemplate::AddonDomain::get_sub_domain( $self->{'user'}, $self->{'domain'} );
            if( $sub_domain ){
                if( $self->_load_userdata( $sub_domain ) ){
                    $vhost{'vhost'} = $self->{'vhost'};
                    $vhost{'vhost'}{'servername'} = $self->{'domain'};
                    $vhost{'vhost'}{'serveralias'} = 'www.'.$self->{'domain'};
                    $vhost{'vhost'}{'serveradmin'} =~ s/$sub_domain/$self->{'domain'}/;
                }
                else{
                    Cpanel::Logger::logger(
                        {
                            'message' => 'Unable to load userdata for '. $sub_domain,
                            'level' => 'warn',
                            'service' => 'simpletemplate::add'
                        }
                    );
                }
            }
            else{
                Cpanel::Logger::logger(
                    {
                        'message' => 'Unable to obtain associative sub domain for '. $self->{'domain'},
                        'level' => 'warn',
                        'output' => 0,
                        'service' => 'simpletemplate::add',
                        'backtraace' => 0,
                    }
                );
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
    else{
        if( $self->_load_userdata() ){
            $vhost{'vhost'} = $self->{'vhost'};
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

1;
