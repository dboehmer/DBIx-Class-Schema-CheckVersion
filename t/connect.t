#!/usr/bin/env perl

use strict;
use warnings;

use Test::Most;

{
    package MyApp::Schema;

    use base 'DBICx::DH::VersionCheck';
}

ok my $schema = MyApp::Schema->connect("dbi:SQLite::memory:"), "connect";

isa_ok $schema, "DBIx::Class::Schema";
isa_ok $schema, "DBICx::DH::VersionCheck";

done_testing;
