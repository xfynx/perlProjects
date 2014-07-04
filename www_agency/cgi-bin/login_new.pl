#!/usr/bin/perl -w
use HTML::Template;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use DBI;
use Digest::MD5 qw(md5_hex);

print "Content-type: text/html\n\n";

my $tpl = HTML::Template->new(filename => '/var/www/tmpl/index.tmpl');

my $email = param("EMAIL");
my $password = param("PASSWORD");

$password = md5_hex($password);

open FILE, '../auth.txt';
@data = <FILE>;
$isNotAdminOrUser = 1;
while (defined ($file_line = <FILE>)) {
        if($file_line eq 'admin') { $isNotAdminOrUser = 0; }
        if($file_line eq 'user') { $isNotAdminOrUser = 0; }
}
close FILE;

if($isNotAdminOrUser){
    $db = DBI->connect('DBI:mysql:agency;host=localhost:3306', 'root', '123', { RaiseError => 1 });
    my $query = $db->prepare("select login, is_admin from user where login like '".$email."' and password like '".$password."';");
    $query->execute() or die($db->errstr);

    @row = $query->fetchrow_array();

    $mail = $row[0];
    $query->finish();
    $db->disconnect;

    if ($mail && defined($mail)) {
        unlink "../auth.txt";
        my $role;
        if($row[1]==0){$role='user';}
        else{$role='admin';}

        open(FILE, "> ../auth.txt");
        print FILE $email;
        print FILE "\n";
        print FILE $role;
        close FILE;

        $tpl->param(MAIL => $email, ROLE => $role);
    }
    else{
      $mail = undef;
    }
}
else{
    $tpl->param(MAIL => $data[0], ROLE => $data[1]);
}
print $tpl->output;
exit;