#!/usr/bin/perl
use strict;
use warnings;

use DBI;

my $dbfile = "cold-storage.db";

my $dsn 	= "dbi:SQLite:dbname=$dbfile";
my $user 	= "";
my $password 	= "";
my $dbh = DBI->connect($dsn, $user, $password, {
	PrintError 	=> 0,
	RaiseError 	=> 1,	
	AutoCommit 	=> 1,	
	FetchHashKeyName => 'NAME_lc',	
});

# create a string with the stuff up until END_SQL
# for BOOLEAN 0 is false and 1 is true
my $sql = <<'END_SQL';
CREATE TABLE provisions (
	id 		INTEGER PRIMARY KEY,
	item 		VARCHAR(50),
	category 	VARCHAR(50),
	inout 		BOOLEAN,  
	quantity 	INTEGER
)
END_SQL

$dbh->do($sql);

$dbh->disconnect;
