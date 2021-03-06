# --
# AccessKeys.t - tests to avoid duplicate accesskeys
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use vars (qw($Self));
use utf8;

# check used accesskeys in agent frontend
my %UsedAccessKeysAgent;

# frontend and toolbar modules
my %AgentModules = (
    %{ $Self->{ConfigObject}->Get('Frontend::Module') },
    %{ $Self->{ConfigObject}->Get('Frontend::ToolBarModule') }
);

ACCESSKEYSAGENT:
for my $AgentModule ( sort keys %AgentModules ) {

    # check navbar items
    if ( $AgentModules{$AgentModule}->{NavBar} && @{ $AgentModules{$AgentModule}->{NavBar} } ) {

        NAVBARITEMS:
        for my $NavBar ( sort @{ $AgentModules{$AgentModule}->{NavBar} } ) {

            my $NavBarKey = $NavBar->{AccessKey} || '';
            next NAVBARITEMS if !$NavBarKey;

            $Self->False(
                defined $UsedAccessKeysAgent{$NavBarKey},
                "[AGENT FRONTEND] Check if access key already exists for access key '$NavBarKey'",
            );

            $UsedAccessKeysAgent{$NavBarKey} = 1;
        }
    }

    my $AccessKey = $AgentModules{$AgentModule}->{AccessKey} || '';
    next ACCESSKEYSAGENT if !$AccessKey;

    $Self->False(
        defined $UsedAccessKeysAgent{$AccessKey},
        "[AGENT FRONTEND] Check if access key already exists for access key '$AccessKey'",
    );

    $UsedAccessKeysAgent{$AccessKey} = 1;
}

# check used accesskeys in customer frontend
my %UsedAccessKeysCustomer;

# frontend and toolbar modules
my %CustomerModules = %{ $Self->{ConfigObject}->Get('CustomerFrontend::Module') };

ACCESSKEYSCUSTOMER:
for my $CustomerModule ( sort keys %CustomerModules ) {

    # check navbar items
    if (
        $CustomerModules{$CustomerModule}->{NavBar}
        && @{ $CustomerModules{$CustomerModule}->{NavBar} }
        )
    {

        NAVBARITEMS:
        for my $NavBar ( sort @{ $CustomerModules{$CustomerModule}->{NavBar} } ) {

            my $NavBarKey = $NavBar->{AccessKey} || '';
            next NAVBARITEMS if !$NavBarKey;

            $Self->False(
                defined $UsedAccessKeysCustomer{$NavBarKey},
                "[CUSTOMER FRONTEND] Check if access key already exists for access key '$NavBarKey'",
            );

            $UsedAccessKeysCustomer{$NavBarKey} = 1;
        }
    }
}

1;
