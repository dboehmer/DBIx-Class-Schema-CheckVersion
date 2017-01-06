#!/usr/bin/env perl

use strict;
use warnings;

use DBICx::TestDatabase;
use DBIx::Class::DeploymentHandler;
use lib "t/lib";
use Test::Exception;
use Test::Most;

ok my $schema = DBICx::TestDatabase->new("MyApp::Schema");

isa_ok $schema, "DBIx::Class::Schema";
isa_ok $schema, "DBIx::Class::Schema::VersionCheck";

throws_ok { $schema->check_version } qr/no such table/,
  "database without version info";

# install version meta table
my $dh = DBIx::Class::DeploymentHandler->new(
    schema          => $schema,
    force_overwrite => 1,         # TODO use temp dir
);
local $MyApp::Schema::VERSION = 2;
$dh->prepare_version_storage_install;
$dh->install;

lives_ok { $schema->check_version } "database up to date";

{
    local $MyApp::Schema::VERSION = 1;
    throws_ok { $schema->check_version } qr/new/, "database too new";

    local $MyApp::Schema::VERSION = 3;
    throws_ok { $schema->check_version } qr/old/, "database too old";
}

my $called_up_to_date = 0;
local *MyApp::Schema::_database_up_to_date = sub { $called_up_to_date++ };
$schema->check_version;
is $called_up_to_date => 1,
  "successful checked called _database_up_to_date()";

done_testing;
