#!/usr/bin/perl -w
use HTML::Template;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use DBI;

print "Content-type: text/html\n\n";

open(FILE, "../../auth.txt");
my $isAdmin;
while (defined (my $file_line = <FILE>)) {
        if($file_line eq 'admin') { $isAdmin=1; }
}
close FILE;

if($isAdmin){
  my $id = param("id");
  my $name = param("name");
  
  $db = DBI->connect('DBI:mysql:library;host=localhost:3306', 'root', '123', { RaiseError => 1 });
  
  my $data=$db->do("update author set name='$name' where id=$id;");
  $db->disconnect();

  print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/author/showAuthor.pl?id='.$id.'"></html>';
}
else{
    print '<html><META http-equiv="refresh" content="0; http://localhost/cgi-bin/login_new.pl"></html>';
}
exit;