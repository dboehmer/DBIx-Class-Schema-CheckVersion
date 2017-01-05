package MyApp::Schema;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_components('+DBICx::DH::VersionCheck');

1;
