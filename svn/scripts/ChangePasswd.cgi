#!/usr/bin/perl -w
use strict;
use CGI;
my $time = localtime;
my $remote_id = $ENV{REMOTE_HOST} || $ENV{REMOTE_ADDR};
my $admin_email = $ENV{SERVER_ADMIN};
my $cgi = new CGI;
my $pwd_not_alldiginal = "密码不能全为数字";
my $pwd_not_allchar = "密码不能全为字符";
my $user_not_exists ="该用户不存在";
my $file_not_found ="文件不存在,请联系管理员";
my $authuserfile;
my $logfile;
my $pwdminlen;
my $title;
my $description;
my $yourname;
my $oldpwd;
my $newpwd1;
my $newpwd2;
my $btn_change;
my $btn_reset;
my $changepwdok;
my $changepwdfailed;
my $oldpwderror;
my $passmustgreater;
my $twopassnotmatched;
my $entername;
my $enterpwd;
my $errorpwd;
my $back;
 
&IniInfo;
if ($cgi -> param())
{#8
my $User = $cgi->param('UserName');
my $UserPwd = $cgi->param('OldPwd');
my $UserNewPwd = $cgi->param('NewPwd1');
my $MatchNewPwd = $cgi->param('NewPwd2');
 
if (!$User)
{&Writer_Log("Enter no user name");
&otherhtml($title,$entername,$back);}
elsif (!$UserPwd )
{&Writer_Log("Enter no OldPasswd");
&otherhtml($title,$enterpwd,$back); }
elsif (length($UserNewPwd)<$pwdminlen)
{&Writer_Log("Password's length must greater than".$pwdminlen);
&otherhtml($title,$passmustgreater.$pwdminlen,$back);}
elsif ($UserNewPwd =~/^\d+$/)
{&Writer_Log("New Passwd isn't all diginal");
&otherhtml($title,$pwd_not_alldiginal,$back);}
elsif ($UserNewPwd =~/^[A-Za-z]+$/)
{&Writer_Log("New Passwd isn't all char");
&otherhtml($title,$pwd_not_allchar,$back);}
elsif ($UserNewPwd ne $MatchNewPwd)
{&Writer_Log("Two new passwords are not matched");
&otherhtml($title,$twopassnotmatched,$back);}
else
{if($authuserfile)
{#6
open UserFile, "<$authuserfile" or die "打开文件失败：$!";
while (<UserFile>)
{#5
my $varstr=$_;
if($varstr =~/($User)/)
{#3
my $eqpos =index($varstr, ":");
my $UserName = substr($varstr,0,$eqpos);
my $cryptpwd = substr($varstr,$eqpos + 1,13);
 
next if($UserName ne $User);
 
if(crypt($UserPwd,$cryptpwd) eq $cryptpwd)
{#a
my $rc = system("/usr/bin/htpasswd -b $authuserfile $User $UserNewPwd");
if ($rc == 0)
{#1
&Writer_Log( $User."：Change Passwd");
&otherhtml($title,$changepwdok,$back);
}#1
else
{#2
&Writer_Log( $User."：Change Passwd Failed");
&otherhtml($title,$changepwdfailed,$back);
}#2
exit;
}#a
else
{#b
&Writer_Log("Old Passwd is Incorrect ");
&otherhtml($title,$errorpwd,$back);
}#b
exit;
}#3
else
{#4
if(eof)
{ &Writer_Log($User."：no this user");
&otherhtml($title,$user_not_exists,$back);
exit;
}
else
{next;}
}#4
}#5
close UserFile;
}#6
else
{#7
&Writer_Log($authuserfile."：no found");
&otherhtml($title,$file_not_found,$back);
}#7
}
}#8
else
{&Index_Html;}
sub IniInfo{
my $inifile = "/var/www/cgi-bin/ChangePasswd.ini";
open CGI_INI_FILE, "<$inifile" or die "打开文件失败：$!";;
while (<CGI_INI_FILE>)
{
my $eqpos =index($_,'=');
my $len = length($_);
if ($_ =~/authuserfile/)
{$authuserfile= substr($_, $eqpos + 1, $len - $eqpos -2);}
elsif ($_ =~/logfile/)
{$logfile= substr($_, $eqpos + 1);}
elsif ($_ =~/pwdminlen/)
{$pwdminlen= substr($_, $eqpos + 1);}
elsif ($_ =~/title/)
{$title = substr($_, $eqpos + 1);}
elsif ($_ =~/description/)
{$description = substr($_, $eqpos + 1);}
elsif ($_ =~/yourname/)
{$yourname = substr($_, $eqpos + 1);}
elsif ($_ =~/oldpwd/)
{$oldpwd= substr($_, $eqpos + 1);}
elsif ($_ =~/newpwd1/)
{$newpwd1= substr($_, $eqpos + 1);}
elsif ($_ =~/newpwd2/)
{$newpwd2= substr($_, $eqpos + 1);}
elsif ($_ =~/btn_change/)
{$btn_change = substr($_, $eqpos + 1);}
elsif ($_ =~/btn_reset/)
{$btn_reset = substr($_, $eqpos + 1);}
elsif ($_ =~/changepwdok/)
{$changepwdok = substr($_, $eqpos + 1);}
elsif ($_ =~/changepwdfailed/)
{$changepwdfailed = substr($_, $eqpos + 1);}
elsif ($_ =~/oldpwderror/)
{$oldpwderror = substr($_, $eqpos + 1);}
elsif ($_ =~/passmustgreater/)
{$passmustgreater = substr($_, $eqpos + 1);}
elsif ($_ =~/twopassnotmatched/)
{$twopassnotmatched = substr($_, $eqpos + 1);}
elsif ($_ =~/entername/)
{$entername = substr($_, $eqpos + 1);}
elsif ($_ =~/enterpwd/)
{$enterpwd= substr($_, $eqpos + 1);}
elsif ($_ =~/errorpwd/)
{$errorpwd= substr($_, $eqpos + 1);}
elsif ($_ =~/back/)
{$back = substr($_, $eqpos + 1);}
}
close CGI_INI_FILE;
}
sub Index_Html
{
print "Content-type: text/html\n\n";
print <<END_OF_PAGE;
<html >
<head>
<title>$title</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
</head>
<body>
<HR>
 
<center><h1>$description</h1>
</center>
<form method="POST" enctype="multipart/form-data" action="/cgi-bin/ChangePasswd.cgi">
<br>
<TABLE align="center">
<TR><TD class="t_text">$yourname</TD><TD><input type="text" name="UserName" /></TD></TR>
<TR><TD class="t_text">$oldpwd</TD><TD><input type="password" name="OldPwd" /></TD></TR>
<TR><TD class="t_text">$newpwd1</TD><TD><input type="password" name="NewPwd1" /></TD></TR>
<TR><TD class="t_text">$newpwd2</TD><TD><input type="password" name="NewPwd2" /></TD></TR>
</TABLE>
<br>
<TABLE align="center">
<TR><TD><input type="submit" name="chgpasswd" value="$btn_change"> <input type="reset" value="$btn_reset"></TD></TR>
</TABLE>
</form>
<HR>
<center><font color="#FF0000">注意:新密码位数必需大于$pwdminlen，且为字母与数字组合</font>
</body>
</html>
END_OF_PAGE
}
sub otherhtml{
print "Content-type: text/html\n\n";
print <<END_OF_PAGE;
<html>
<head>
<meta http-equiv="Content-Language" content="zh-cn">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>$_[0]</title>
</head>
<body>
<p align="center"><font size="5">$_[1]</font></p>
<p align="center"><a href="/cgi-bin/ChangePasswd.cgi"><font size="4">$_[2]</font></a></p>
<HR>
<center>
<P>如有问题请与管理员联系E-Mail: <A HREF="$admin_email.
mailto:$admin_email">$admin_email</A>.</P></center>
 
</body>
  
</html>
END_OF_PAGE
}
sub Writer_Log{
if($logfile)
{
my $loginfo ="[".$time."] "." [".$remote_id."] "." || ".$_[0];
open LOGFILE,">>$logfile" or die "Couldn't open LOG FILE for writing: $!";
print LOGFILE ("$loginfo\n");
close LOGFILE;
}
}
