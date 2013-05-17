#!/usr/bin/perl

use Getopt::Std;
use Getopt::Long;
my $TARGET_SDK="iphoneos6.1";
#my $TARGET_SDK="iphoneos5.1";
#my $TARGET_SDK="iphoneos4.3";

sub usage() {
	print STDERR <<USAGE;
Usage:
	perl onb.pl [-o outputname] [-w workspace] scheme
		
	the generated file are put in {\$PROJECT_DIR}/build/ipa/
	~~~~~~~~~~~~~~~~
	NOTE:
	default is use scheme as output name, however, 
	there is problem dealing with Chinese charactors, 
	so you should specify the [-o outputname]
	~~~~~~~~~~~~~~~~
	
	{\$outputname}.html is for outter use : winsfa.winchannel.net:4010
	{\$outputname}2.html is for inner use : 192.168.1.14:4010

USAGE
	exit(1);
}

our ($opt_o, $opt_w);
getopt('ow');

if (!$ARGV[0]) {
	usage();
}

$outHTMLTemplate = "html_template.html";
$outPLISTTemplate = "plist_template.plist";
generateTemplate();

$projectDir = `pwd`;
chomp($projectDir);

# xcodebuild / xcrun
my $PROJECT_DIR=`pwd`;
chomp($PROJECT_DIR);
my $PROJECT_NAME=$ARGV[0];
print $PROJECT_NAME, "\n";
print $opt_o, "\n";
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# not supporting Chinese
$replacementName = $opt_o;

if ($replacementName) {
	
} else {
	$replacementName = $PROJECT_NAME
}

my $PROJECT_BUILD_DIR = $PROJECT_DIR."/build";
print `rm -rf $PROJECT_BUILD_DIR`;
my $DEVELOPPER_NAME = "iPhone Distribution: Insoftb (China) Co., Ltd.";
my $HOME = $ENV{"HOME"};
my $PROVISIONNING_PROFILE = $HOME."/Library/MobileDevice/Provisioning Profiles/706258C2-5997-42FB-9C32-A3E709CED389.mobileprovision";

print "Begin Build...\n";
print `xcodebuild clean -configuration Release`;
if ($opt_w) {
	print `xcodebuild -workspace "$opt_w" -scheme "$PROJECT_NAME" -sdk "$TARGET_SDK" -configuration Release CONFIGURATION_BUILD_DIR=$PROJECT_BUILD_DIR`;
}
else {
	print `xcodebuild -scheme "$PROJECT_NAME" -sdk "$TARGET_SDK" -configuration Release CONFIGURATION_BUILD_DIR=$PROJECT_BUILD_DIR`;
}

print "Begin Distribution...\n";
print `xcrun -sdk iphoneos PackageApplication -v "$PROJECT_BUILD_DIR/$PROJECT_NAME.app" -o "$PROJECT_BUILD_DIR/$PROJECT_NAME.ipa" --sign "$DEVELOPPER_NAME" --embed "$PROVISIONNING_PROFILE"`;

# get the bundle name
my $plist = "$PROJECT_BUILD_DIR"."/$PROJECT_NAME".".app/Info.plist";
chomp($plist);
print "NOTE: the plist file we use is : $plist\n";
$bundle = `/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" $plist`;
chomp($bundle);
print "NOTE: the bundle id is : $bundle";

# generate the html / plist from template
#$name    = "xybc";
$name = $replacementName;
$ipOutter = "winsfa.winchannel.net:4010";
$ipInner = "192.168.1.14:4010";
$io = undef;

print `mkdir $projectDir/build`;
print `mkdir $projectDir/build/ipa`;
print `mkdir $projectDir/build/ipa/$name`;

genFunc($name, $ipOutter, $bundle);
genFunc($name, $ipInner, $bundle, 2);

sub genFunc {
my ($myname, $myip, $mybundle, $myio) = @_;	
	
	my $outname = $myname.$myio;

	my $htmlFilename  = "html_template.html";
	my $plistFilename = "plist_template.plist";
	my $ipaName       = $myname . ".ipa";

	open HTML,     "<$htmlFilename";
	open HTML_OUT, ">$outname.html";
	while (<HTML>) {
		s/\$template:name\$/$myname/g;
		s/\$template:io\$/$myio/g;
		s/\$template:ip\$/$myip/g;
		print HTML_OUT $_;
	}

	open PLIST,     "<$plistFilename";
	open PLIST_OUT, ">$outname.plist";

	while (<PLIST>) {
		s/\$template:name\$/$myname/g;
		s/\$template:ip\$/$myip/g;
		s/\$template:ipa\$/$myname/g;
		s/\$template:bundle\$/$mybundle/g;
		print PLIST_OUT $_;
	}
	
	
	print `mv $outname.html $projectDir/build/ipa`;
	print `mv $outname.plist $projectDir/build/ipa/$myname`;
}

removeTemplate();

# move the ipa to the right place
print `mv $projectDir/build/$PROJECT_NAME.ipa $projectDir/build/ipa/$name/$replacementName.ipa`;

# generate html / plist template, so that we have 1 perl file other than 1 perl file + 2 template files

sub removeTemplate {
print "NOTE: removing template file\n";
	#my $outHTMLTemplate = "html_template.html";
	#my $outPLISTTemplate = "plist_template.plist";
	
	print `rm $outHTMLTemplate`;
	print `rm $outPLISTTemplate`;
}

sub generateTemplate {
print "NOTE: generating template file\n";
	#my $outHTMLTemplate = "html_template.html";
	#my $outPLISTTemplate = "plist_template.plist";
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	open HTML, ">$outHTMLTemplate";
	print HTML << "HTML";
	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>软件下载</title>
<style type="text/css">
div,p,span,h3,button{
	margin:0;
	padding:0;
	border:0;
	}
.software{
	}
.software h3{
	background:url() center center no-repeat;
	width:400px;	
	height:260px;
	overflow:hidden;
	display:block;
	float:left;
	text-indent:-9999px;
	}
.declare{
	margin-top:5px;
	width:220px;
	display:inline-block;
	margin-left:20px;
	}
.declare p{
	font-size:16px;
	font-family:Arial, Helvetica, sans-serif;
	color:#3c5ec2;
	line-height:24px;	
	}
.declare a{
	width:191px;
	height:45px;
	display:block;
	overflow:hidden;
	background:url(images/yshb_dl_btn.png) center center no-repeat;
	margin:20px 20px 0px 10px;
	text-indent:-9999px;
	}

</style>
</head>



<body>

<div class="software">
	<h3>\$template:name\$</h3>
    <div class="declare">
    	<p>北京赢销通软件科技有限公司开发的移动销售系统是一款适用于各种手机操作系统的销售团队管理软件。移动销售系统的使命是为大家提供国内领先的消费品行业营销领域管理解决方案，从而帮助企业构建营销管理体系。</p>
		<span><a href="itms-services://?action=download-manifest&url=http://\$template:ip\$/\$template:name\$/\$template:name\$\$template:io\$.plist">demo下载</a></span>  
		
	</div>

</div>

</body>
</html>

HTML
	
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	open PLIST, ">$outPLISTTemplate";
	print PLIST << "PLIST";
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>items</key>
	<array>
		<dict>
			<key>assets</key>
			<array>
				<dict>
					<key>kind</key>
					<string>software-package</string>
					<key>url</key>
					<string>http://\$template:ip\$/\$template:name\$/\$template:name\$.ipa</string>
				</dict>
			</array>
			<key>metadata</key>
			<dict>
				<key>bundle-identifier</key>
				<string>\$template:bundle\$</string>
				<key>bundle-version</key>
				<string>1.0</string>
				<key>kind</key>
				<string>software</string>
				<key>title</key>
				<string>\$template:name\$</string>
			</dict>
		</dict>
	</array>
</dict>
</plist>

PLIST
}
