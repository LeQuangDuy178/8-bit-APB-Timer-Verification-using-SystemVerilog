##-----------------------------------------regress.pl---------------------------
# Main purpose of Perl
# 1st: Read file and perform file execution or file manamagement
# 2nd: Perform specific purpose same as every programming language
# 3rd: Read, filter and extract appropriate structure of every data such as integer, string

# Perl library directory
#! /usr/bin/perl

##--------------------------------------------------------
# Perl and Linux knowledge
# $ datatype stores integer, float, string, etc.
# @ datatype store array
# % datatype store versatile data such as struct, class 
# scalar() returns array/list no. of elements/concatenating values/force returning single value
# time() returns current time stamp since Unix epoch (January 1, 1970, 00:00:00 UTC)
# system () operate appropriate Linux system command inside 
# shift() remove the first element of an array and return that value
# '' execute command line specify in Makefile
# `` blacktickoperator execute system command and capture standard output (interact with external cmd)
# | pipe sysmbol chaining cmd together: take output of 1 cmd and feed as input to another cmd
# =~ to set string expression -> bind a regular expression in "/.../" to string for pattern check
# String Expression Langue (SpEL) in Perl 
# String Interpolation: $"string" = "string"
# Regular Expression: d+, w+, /^\/, etc. (scanf opt like %d, %t, %h)
# Template Toolkit: template engine for custom defined string expression
# split() divide line into substring store in @"array" with elements separated by delimiter
# `grep (Global Regular Expression Print) search for plain-text data sets for lines matching RE
# `sed search for specific pain-text pattern and return the line: sed 's/old/new/g' file.txt
# -r is recursively parse and scan all included directories and subdirectories
# -f is perform execution forcefully
# -L execute the command to the actual target followed by symbolic link if files are linked to another
# -e search for matching specific plain-text pattern to be edited or targeted and return the renewed 
# -l requires system to display more detail about information alongside with ls 
# >> operator appends the output of command to the specified file at the end of it
# wc counts the total number of words in files or subfiles
# /g instruct Perl to search for matched pattern globally, not a single one 
# ^ pattern match beginning of string
# \s pattern match whitespace
# + pattern match one or more specified tokens
# " is interpolation allows to embed defined variable and expression within string
# \r escape sequence represents a carriage return character -> move cursor to beginning of current line
# \Q and \E start and end quoting metacharacters in RE -> match literal string then return 1
# <<EOF is herodoc, define multi-line strings, should end with EOF in beggining of end line
# @_ is special array hold arguments passed into subroutine
##--------------------------------------------------------

use Getopt::Long; # Perl built-in library -> To get the optional command input

# Variables with associated datatype include -> call them together when used
my $cov; # Enable coverage
my @tc_list; # Test case list in array
my $pass_key_word; # Store "TEST PASSED" keyword in regress.cfg
my $fail_key_word; # Store "TEST FAILED" keyword in regress.cfg
my $start_time; # Store start time
my $end_time; # Store end time -> Calculate simulation time

# Perl specific task/function command line block
GetOptions (
    'f|file=s' => \$opt_file,
    'r|report!' => \$opt_report,
    'h|help!' => \$opt_help
);

# Run the main() function
main()

# Declare main() tasks
sub main {
    if ($opt_help) {
        print_usage(); # Print user guide if user enter: ./regress.pl -help 
    }

    elsif ($opt_report) {
        report(); # Generate report file and open report regress.rpt: ./regress.pl -r
    }

    else { # If only: ./regress.pl then
        parse_cfg(); # Parse the configuration declared in the regress.cfg file 
        run_regress(); # Run regression multiple testcases
        report(); # Generate report
    }
}

# Declare all functions above
#---------------------------------------------------
# run_regress()

sub run_regress {
  my $tc; # Store testcase name in log file
  my $seed; # Store seed name in log file
  my $plusarg; # Store arguments for each testcase
  $start_time = time(); # Start counting time
  system "make build"; # Call Makefile make build command
  my $size = scalar(@tc_list); # Get size of regression running (total testcases) -> scalar()
  for (my $i = 0, $i < $size; $i = $i + 3) { # Loop through testcases
    $tc = shift(@tc_list); # Take every first elements from @tc_list each loop 
    $tc =~ s/\s+//g; # Spring expression (ANALYZE LATER)
    $seed = shift(@tc_list); # Extract seed number
    $plusarg = shift(@tc_list); # Extract plusarg
    $plusarg =~ s/^\s+//; # Extact plusarg name
    system ("make run TESTNAME=$tc SEED=$seed RUNARG=$plusarg"); # Makefile command by test.log
    $end_time = time();
  }
}
#---------------------------------------------------
# parse_cfg()

sub parse_cfg {
  my $cfg_file; # Config file name: regress.cfg
  my $tc_start; # Store tc_list flag to start tc_list parsing
  my $run_time; # Store total number of runs per testcase in run_time
  my $run_opts; # Store run_opts (apply in UVM)
  my @run_string; # Store an array of testcases, each element is testcase name-seed-plusarg

  if (defined $opt_file) {
    $cfg_file = $opt_file; # No specifying custom file name to parse
  }
  else {
    $cfg_file = "regress.cfg"; # Then default parsing file is regress.cfg
  }

  # Parse regress.cfg
  open(my $fh, '<', $cfg_file) or die "Can't open regress.cfg file $cfg_file!\n";
  while (my $line = <$fh>) { # Looping scan through all line in the file and store to $line
    chomp $line; # Remove/avoid new line/blank line
    next if $line =~ /^#/; # String expression to implement line containing content
    if ($line =~ /^\s*cov\s*=\s*(w+)/) { # Detect if the line has content: "cov = (w+)" (with space)
      $cov = $1;
    } 
    elsif ($line =~ /pass_key_word/) { # Detect if the line has content: pass_key_word
      $pass_key_word = $line; # Store the content of the line to $pass_key_word
      $pass_key_word =~ s/pass_key_word//g; # Extract and remove "pass_key_word"
      $pass_key_word =~ s/=//g; # Extract and remove "="
    }
    elsif($line =~ /fail_key_word/) { # Detect if the line has content: fail_key_word
      $fail_key_word = $line; # Store content of that line to $fail_key_word
      $fail_key_word =~ s/fail_key_word//g; # Extract and remove "fail_key_word"
      $fail_key_word =~ s/=//g; # Extract and remove "="
    }
    elsif($line =~ /tc_list/) { # Detect if the line has content: tc_list
      $tc_start = $1; # Set $tc_start to true (variable and value always come with $...)
    }
    elsif($tc_start) {
        if ($line =~ /\}/) {$tc_start = 0;} # If detect line with end curly '}' -> end tc_list
        else { # Parse remaining content in tc_list{}
          $line =~ s/;$//; # Filter and remove ';' in last string
          @run_string = split(/,/,$line); # Divide line into substring @run_string by delimiter ','
          $run_time = $run_string[1]; # Get the string "run_times=0" as index [1] in array
          $run_time =~ s/run_times=//g; # Extract "run_times" to get the number of run_time only
          $run_opts = $run_string[2]; # Get "run_opts=..." as index [2] in array
          $run_opts =~ s/run_opts=//g; # Extract "run_opts=" and get "..." (UVM feature)
          $run_opts =~ s/([+])/ $1/g; # Extract sth with [+] and $1 (NOTE)
          for (my $i = 0; $i < $run_time; $i++) { # Loop through single test execute under run_time
            # 1 TC, 2 SEED, 3 PLUSARG store as log file name
            # Log file in log folder: TC_SEED_PLUSARG
            push @tc_list, $run_string[0]; # Push testcase name as index [0] to @tc_list
            push @tc_list, int(rand(999999 - 100000 + 1)) + 100000; # Push random seed
            push @tc_list, $run_opts; # Push plusarg (UVM feature)
          }
        }
    }
  }
}
#---------------------------------------------------
# report()

sub report {
  my $tc_run; # Store total number of testcases run
  my $tc_pass; # Store total number of testcases passed
  my $tc_fail; # Store total number of testcases failed
  my $tc_unknown; # Store total number of testcases unknowned (not PASSES/FAILED)
  my $used_time; # Store total simulation time

  #-----------------------------------------------------
  # Report generating
  # Strategy: write the string regression, filtering implementation in temp cache file
  # -> Then read them and write to the complete file regress.rpt
  print "Generate report...\n"; # Print to console 
  system ("rm -rf tmp_report"); # Remove tmp_report file recursively and forcefully 
  system ("grep -L -e $pass_key_word -e $fail_key_word log/*.log >> tmp_report"); 
  # grep search in regress.cfg for line with 2 keywords in every log files and append them to tmp_report
  system ("grep $fail_key_word log/*.log >> tmp_report"); # Search keyword in all log append to file
  system ("grep $pass_key_word log/*.log >> tmp_report"); # Search keyword in all log append to file
  
  $tc_pass      = `grep $pass_key_word log/*.log | wc -l`; # Search keyword and count them with info
  $tc_fail      = `grep $fail_key_word log/*.log | wc -l`; # Search and count with detail
  $tc_unknown   = `grep -L -e $pass_key_word -e $fail_key_word log/*.log | wc -l`;
  $used_time    = $end_time - $start_time; # Calculate $used_time simulation time
  $used_time    = format_time($used_time); # Format time for display
  $pass_key_word =~ s/"//g; # Search and extract $pass_key_word and return newly extracted to it
  $pass_key_word =~ s/^\s+//; # Search and extract multiple whitespaces at beginning and so on
  $fail_key_word =~ s/"//g;
  $fail_key_word =~ s/^\s+//; 
  #------------------------------------------------------
  # Reading tmp_report and write to regress.rpt
  
  # Reading file
  open(my $read_fh, '<', "tmp_report") or die "Cannot open tmp_report!\n";
  
  # Writing file
  open(my $write_fh, '>', "regress.rpt") or die "Cannot open regress.rpt!\n";
  print $write_fh "#############################################################\n";
  print $write_fh "####                   ICTC Regression Report            ####\n";
  print $write_fh "#############################################################\n";
  printf $write_fh "Total testcase run: %d\n", $tc_pass + $tc_fail + $tc_unknown;
  print $write_fh "Passed             : $tc_pass";
  print $write_fh "Failed             : $tc_fail";
  print $write_fh "Unknown            : $tc_unknown";
  printf $write_fh "Used time         : $used_time\n";
  print $write_fh "------------------------------------------------------------------\n";
  print $write_fh "Run log detail:\n";

  # Print details of testcases name_seed_plusarg.log and their status
  while (my $line = <$read_fh>) { # Read every lines in tmp_report (containing detail report)
    chomp($line); # Avoid blank lines
    $line =~ s/\r//g;
    if ($line =~ /\Q$pass_key_word\E/) { # If search literal "TEST_PASSED" stored in $pass_key_word
      $line =~ s/#.*//; # Avoid comment in all lines beginning with "#"
      print $write_fh "$line ==> Passed\n"; # Print status of tests in the line of $line
    }
    elsif ($line =~ /\Q$fail_key_word\E/) {
      $line =~ s/#.*//;
      print $write_fh "$line ==> Failed\n";
    }
    else {
      print $write_fh "$line ==> Unknown\n";
    }
  }
  print $write_fh "------------------------------------------------------------\n";
  system ("rm -rf tmp_report");
  #------------------------------------------------------
}
#--------------------------------------------------------
# print_usage()

sub print_usage {
  print <<EOF;
  This script supports regression feature
  regress.pl -{options}"
    -f|file=s       : Run regression with regress.cfg file
    -r|report!      : Report regression result

  Example to run regression:
    ./regress.pl    : Start run regression with regress.cfg file within this directory
    ./regress.pl -r : Re-generate report regress.rpt
EOF
}
#---------------------------------------------------------
# format_time()

sub format_time {
    my ($seconds) = @_;

    if ($seconds < 60) {
        return "$seconds s";
    } elsif ($seconds < 3600) {
        my $minutes = int($seconds / 60);
        my $remaining_seconds = $seconds % 60;
        return "$minutes m" . ($remaining_seconds > 0 ? " $remaining_seconds s" : "");
    } else {
        my $hours = int($seconds / 3600);
        my $remaining_minutes = int(($seconds % 3600) / 60);
        my $remaining_seconds = $seconds % 60;
        return "$hours h" . ($remaining_minutes > 0 ? " $remaining_minutes m" : "") . ($remaining_seconds > 0 ? " $remaining_seconds s" : "");
    }
}
#---------------------------------------------------------