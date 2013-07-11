#!/usr/bin/perl   
use warnings;  

sub GETCPUPERCENTER
{
  $SLEEPTIME=5;  #单位s
 
  if (-e "/tmp/stat") {  
    unlink "/tmp/stat";
    }  
  open (JIFF_TMP, ">>/tmp/stat") || die "Can't open /tmp/stat file!\n";  
  open (JIFF, "/proc/stat") || die "Can't open /proc/stat file!\n";
  @jiff_0=<JIFF>;
  print JIFF_TMP $jiff_0[0];
  close (JIFF);  
 
  sleep $SLEEPTIME;
 
  open (JIFF, "/proc/stat") || die "Can't open /proc/stat file!\n";
  @jiff_1=<JIFF>;  
  print JIFF_TMP $jiff_1[0];  
  close (JIFF);  
  close (JIFF_TMP);  
  
  #一行一行的读取指定的文件， 以空格作为分隔符
  @USER=`awk '{print \$2}' "/tmp/stat"`;    #从系统启动开始累计到当前时刻，用户态的CPU时间（单位：jiffies） ，不包含 nice值为负进程。1jiffies=0.01秒
  @NICE=`awk '{print \$3}' "/tmp/stat"`;    #从系统启动开始累计到当前时刻，nice值为负的进程所占用的CPU时间（单位：jiffies）
  @SYSTEM=`awk '{print \$4}' "/tmp/stat"`;  #从系统启动开始累计到当前时刻，核心时间（单位：jiffies）
  @IDLE=`awk '{print \$5}' "/tmp/stat"`;    #从系统启动开始累计到当前时刻，除硬盘IO等待时间以外其它等待时间（单位：jiffies）
  @IOWAIT=`awk '{print \$6}' "/tmp/stat"`;  #从系统启动开始累计到当前时刻，硬盘IO等待时间（单位：jiffies） 
  @IRQ=`awk '{print \$7}' "/tmp/stat"`;     #从系统启动开始累计到当前时刻，硬中断时间（单位：jiffies）
  @SOFTIRQ=`awk '{print \$8}' "/tmp/stat"`; #从系统启动开始累计到当前时刻，软中断时间（单位：jiffies）
  
  $JIFF_0=$USER[0]+$NICE[0]+$SYSTEM[0]+$IDLE[0]+$IOWAIT[0]+$IRQ[0]+$SOFTIRQ[0];  
  $JIFF_1=$USER[1]+$NICE[1]+$SYSTEM[1]+$IDLE[1]+$IOWAIT[1]+$IRQ[1]+$SOFTIRQ[1];  
  
  $SYS_IDLE=($IDLE[0]-$IDLE[1]) / ($JIFF_0-$JIFF_1) * 100;  #两次采样，取差值
  $SYS_USAGE=100 - $SYS_IDLE;  
 
  return $SYS_USAGE;
}

while(1){
  my $cpu_usage=&GETCPUPERCENTER;
  printf ("The CPU usage is %1.2f%%",$cpu_usage);
  if($cpu_usage>20){
    print "\tThe CPU usage is high!";
    }
  print "\n";
}  
  
   
