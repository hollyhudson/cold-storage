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
})
	or die "Could not connect to datase: " . DBI->errstr;

### Insert some stuff

my $item1 = 'pears';
my $category1 = 'fruit';
my $item2 = 'kale';
my $category2 = 'vegetables';
my $item3 = 'carrots';
my $category3 = 'vegetables';

$dbh->do('INSERT INTO provisions (item, category, quantity, inout) VALUES (?,?,?,?)',
	undef,
	$item1, $category1, 0, 1);

$dbh->do('INSERT INTO provisions (item, category, quantity, inout) VALUES (?,?,?,?)',
	undef,
	$item2, $category2, 0, 1);

$dbh->do('INSERT INTO provisions (item, category, quantity, inout) VALUES (?,?,?,?)',
	undef,
	$item3, $category3, 0, 1);

### Read it back

my $sql = 'SELECT item, inout, quantity FROM provisions WHERE category == ?';
# $sth is a statement handle object
my $sth = $dbh->prepare($sql);
$sth->execute('vegetables');
while (my $row = $sth->fetchrow_hashref) {
	print "item: $row->{item}  quantity: $row->{quantity}  on hand? $row->{inout}\n";
}

### Update it

my $new_quantity = 5;
my $item_to_find = 'kale';

$dbh->do('UPDATE provisions SET quantity = ? WHERE item = ?',
	undef,
	$new_quantity, $item_to_find);

### Read it back (again)

my $sql = 'SELECT item, inout, quantity FROM provisions WHERE category == ?';
my $sth = $dbh->prepare($sql);
$sth->execute('vegetables');
while (my $row = $sth->fetchrow_hashref) {
	print "item: $row->{item}  quantity: $row->{quantity}  on hand? $row->{inout}\n";
}

### Delete something

my $item_to_delete = 'kale';

$dbh->do('DELETE FROM provisions WHERE item = ?',
	undef,
	$item_to_delete);

### Read it back (again)

my $sql = 'SELECT item, inout, quantity FROM provisions WHERE category == ?';
my $sth = $dbh->prepare($sql);
$sth->execute('vegetables');
while (my $row = $sth->fetchrow_hashref) {
	print "item: $row->{item}  quantity: $row->{quantity}  on hand? $row->{inout}\n";
}

$dbh->disconnect;
