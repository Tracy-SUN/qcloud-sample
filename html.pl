
#!/usr/bin/perl

 use strict;
 use warnings;
 use File::Find ();
 use File::Basename;
 
my ($path) = @ARGV;
my $file_name;
my $dir_name;
my $suffix_name;

my $pic_cnt = 0;
my $txt_cnt = 0;
my $video_cnt = 0;
my $audio_cnt = 0;

my $log_re;
my $liveonqcloud_com;
my $xanderwang_top;

sub scan_file{	
    my @files = glob($_[0]);
    
    foreach (@files){
        if(-d $_){
            my $path = "$_/*";
            scan_file($path);
            #print "path: $_\n";
        }elsif(-f $_){
            print $log_re "*$_\n";
            gen_html($path, $_);
        }
    }   
}

sub print_total{	
	print "pic : $pic_cnt\n";
	print "txt : $txt_cnt\n";
	print "video : $video_cnt\n";
	print "audio : $audio_cnt\n";
	}
	
open($log_re, '>', "debug.log");	
open($liveonqcloud_com, '>', "liveonqcloud_com_url.log");	
open($xanderwang_top, '>', "xanderwang_top_url.log");	
scan_file($path);
print_total();
close $log_re;  
close $liveonqcloud_com;
close $xanderwang_top;
	
sub gen_html{
	
	my $file_out;
	
	$path = $_[0];
	my($file_name, $dir_name, undef) = fileparse($_[1]);
	my(undef, undef, $suffix_name) = fileparse($_[1], qr"\..*");
	$suffix_name = substr $suffix_name, 1;
	$file_out = $file_name;
	$file_out =~ /^(.*)\.\w+$/;
	$file_out = $1;
	$dir_name = substr $dir_name, 4 ;
	my $live_url = "www\.liveonqcloud\.com\/". $dir_name. $file_out. ".html";
	my $xander_url = "www\.xanderwang\.top\/". $dir_name. $file_out. ".html";
	$file_out = "html/". $dir_name. $file_out. ".html";
	
	print $liveonqcloud_com "$live_url\n";
	print $xanderwang_top "$xander_url\n";
#	print "file: $file_name\n";
#	print "##dir: $dir_name\n";
#	print "##suffix: $suffix_name\n";
#	print "##file-out: $file_out\n---\n\n";
  
  print_header($file_out, 1);
   	
if ($dir_name =~ /audio/){
   print_audio($file_out,$audio_cnt, $_[1],$suffix_name);
   $audio_cnt += 1;

} else {
	if ($dir_name=~ /video/){
  	print_video($file_out, $video_cnt, $_[1],$suffix_name );
  	$video_cnt += 1;
	} else {
		if ($dir_name =~ /txt/){
   		print_txt($file_out, $txt_cnt, $_[1]);
   		$txt_cnt += 1;
		} else {
			if ($dir_name =~ /pic/){
    			print_pic($file_out, $pic_cnt, $_[1]);
   			$pic_cnt += 1;
   			
   		}
   		else {
   			print "***other file: \n";
   			#print_video($file_out,  $_[1]);
   		}
   		}
		}
	}
			
}


sub print_audio {
	my $fo;
	open($fo, '>>', $_[0]);
	####  body   ####
	print $fo "\n\n<body> \n";
	print $fo "\t<div class=\"container\">\n";
	print $fo "\t\t<h1 align=\"center\">红蓝样本-音频</h1>\n";	
	
	print $fo "\t\t<h2 align=\"center\">编号 音频-$_[1]</h2>\n\t</div>\n";
		
	print $fo "\n\t\<p align=\"center\">  \n\t\t<audio controls>  \n\t\t\t<source src=\"..\/..\/$_[2]\" type=\"audio\/$_[3]\">   \n\t\t</audio> \n\t</p>\n";	

		
	print $fo "\n</body>\n</html> \n";	
	close $fo;
	}

sub print_video {
	my $fo;
	open($fo, '>>', $_[0]);
	####  body   ####
	print $fo "\n\n<body> \n";
	print $fo "\t<div class=\"container\">\n";
	print $fo "\t\t<h1 align=\"center\">红蓝样本-视频</h1>\n";	
	print $fo "\t\t<h2 align=\"center\">编号 视频-$_[1]</h2>\n\t</div>\n";
	
	#print $fo "\n\t<p align=\"center\">  \n\t\t<video  width=\"640\" height=\"480\" controls> \n\t\t\t<source src=\"..\/..\/$_[2]\" type=\"video\/$_[3]\"> \n\t\t</video> \n\t</p>\n\n" ;
	print $fo "\n\t<p align=\"center\">  \n\t\t<video  controls> \n\t\t\t<source src=\"..\/..\/$_[2]\" type=\"video\/$_[3]\"> \n\t\t</video> \n\t</p>\n\n" ;

	print $fo "</body>\n</html> \n";	
	close $fo;
	
	}

sub print_txt {
	my $fo;
	open($fo, '>>', $_[0]);

	####  body   ####
	print $fo "\n\n<body> \n";
	print $fo "\t<div class=\"container\">\n";
	print $fo "\t\t<h1 align=\"center\">红蓝样本-文本</h1>\n";	
	print $fo "\t\t<h2 align=\"center\">编号 文本-$_[1]</h2>\n\t</div>\n\n";
	
	print $fo "\n\t<object  align=\"middle\" data=\"..\/..\/$_[2]\" > \n\t</object>\n\n";
		
	print $fo "</body>\n</html> \n";	
	close $fo;	
	}



sub print_pic {
	my $fo;
	open($fo, '>>', $_[0]);
	####  body   ####
	print $fo "\n\n<body> \n";
	print $fo "\t<div class=\"container\">\n";
	print $fo "\t\t<h1 align=\"center\">红蓝样本-图片</h1>\n";	
	print $fo "\t\t<h2 align=\"center\">编号 图片-$_[1]</h2>\n\t</div>\n\n";
	
	print $fo "<p align=\"center\"><img id=\"{z1-smoke}\" title=\"\" style=\"BORDER-LEFT-WIDTH: 0px; BORDER-RIGHT-WIDTH: 0px; BORDER-BOTTOM-WIDTH: 0px; BORDER-TOP-WIDTH: 0px\" src=\"..\/..\/$_[2]\" align=\"center\" ></p>\n";
	
		
	print $fo "</body>\n</html> \n";	
	close $fo;	
	}


sub print_header {
	
	my $fo;
	open($fo, '>', $_[0]);
	####  head   ####
	print $fo "<!doctype html>\n<html>\n<head>\n"; 
	print $fo "\t<meta charset=\"utf-8\">\n"; 
	print $fo "\t<title>  红蓝对抗样本  </title>\n";
	print $fo "\t <style> \n";
	
	print $fo "\t\t.container { \n";
	print $fo "\t\t\t width: 60%; \n\t\t\t margin: 10% auto 0; \n\t\t\t padding: 2% 5%; \n\t\t\t border-radius: 10px  \n\t\t\t }\n";
	print $fo "\t\t ul { \n\t\t\t  padding-left: 20px; \n\t\t\t}\n";
	
	print $fo "\t\t ul li { \n\t\t\t   line-height: 2.3 \n\t\t\t}\n";	
	print $fo "\t\t a { \n\t\t\t   color: #20a53a \n\t\t\t}\n";	
	
	print $fo "\t\t.footer span { \n";
	print $fo "\t\t\t width: 60%; \n\t\t\t font-size: 16px; \n\t\t\t color: #000; \n\t\t\t zoom: 200%; \n\t\t\t }\n";
	
	
	print $fo "\t</style>\n</head> \n";
	close $fo;
	}
	
	