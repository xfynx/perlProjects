#!/usr/bin/perl -w
use HTML::Template;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use DBI;

print "Content-type: text/html\n\n";

open(FILE, "../../auth.txt");
@data = <FILE>;
$isNotAdminOrUser = 1;
while (defined ($file_line = <FILE>)) {
        if($file_line eq 'admin') { $isNotAdminOrUser = 0; }
        if($file_line eq 'user') { $isNotAdminOrUser = 0; }
}
close FILE;

if($isNotAdminOrUser){
  my $tmpl = HTML::Template->new(filename => '/var/www/tmpl/book.tmpl', option => 'value');

  $db = DBI->connect('DBI:mysql:library;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  my $rows=$db->selectall_arrayref('select book.id, publisher.name as publisher,
                                    author.name as author, book.name, book.date,
                                    book.count from book join publisher join author
                                    where publisher.id = book.id_publisher and author.id = book.id_author
                                    order by author.name, book.name, publisher.name;', {Columns=>{}});
  my $authors=$db->selectall_arrayref('select name from author', {Columns=>{}});
  my $publishers=$db->selectall_arrayref('select name from publisher', {Columns=>{}});
  $tmpl->param(ROWS => $rows || [], AUTHORS => $authors || [], PUBLISHERS => $publishers || []);
  $db->disconnect();

  print $tmpl->output;		 #вывод
}
else{
  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;