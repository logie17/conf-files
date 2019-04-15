#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);

use Mail::IMAPClient;
use IO::Stty;
use IO::Socket::SSL 'SSL_VERIFY_PEER';

use Getopt::Euclid;

use autodie;

use Parallel::ForkManager;

my $passwd = get_password();
my $personal_username = $ENV{PERSONAL_EMAIL_ADDRESS};
my $imap_server = $ENV{PERSONAL_IMAP_SERVER};

my %imapOptions = ( Server         => $imap_server,
                    User           => $personal_username,
                    Password       => $passwd,
                    Ssl            => 1,
                    Socketargs     => [SSL_verify_mode => SSL_VERIFY_PEER],
                    Debug          => 0,
                    Uid            => 1,
                    Keepalive      => 1,
                    Reconnectretry => 3,
                  );

my $folders = get_folders( \%imapOptions );

say STDERR "Got folder list. Idling on each";

my $pm = new Parallel::ForkManager(1000);
for my $folder (@$folders) {
  my $pid = $pm->start and next;

  my $imap = Mail::IMAPClient->new(%imapOptions) or die "Couldn't connect to imap for folder '$folder'";
  $imap->select($folder)                         or die "Couldn't select '$folder'";

  my %ids_saw;
  while(1) {
    my @unseen = $imap->unseen;
    my @newsubjects;
    for my $id( @unseen ) {
      next if $ids_saw{$id};
      $ids_saw{$id} = 1;
      push @newsubjects, $imap->subject($id);
    }

    if( @newsubjects ) {
      alert();
      my $date = `date`;
      chomp $date;
      say "$date; Pid $pid Saw unread email in '$folder':";
      print join('', map {$_ //= ""; "  $_\n"} @newsubjects);

      sleep(60*$ARGV{'--min'}) if $ARGV{'--min'};
    }

    my $IDLEtag     = $imap->idle           or die "idle failed: $@ for folder '$folder'\n";
    my $idle_result = $imap->idle_data(250) or die "idle_data failed: $@ for folder '$folder'\n";
    $imap->done($IDLEtag)                   or die "idle done failed: $@ for folder '$folder'\n";;
  }

  $pm->finish;
}
$pm->wait_all_children;


sub get_password {
  my $path = "$ENV{HOME}/.passwd/loganbell.gpg";
  my $password = `gpg2 --use-agent --quiet --batch -d $path`;
  if ($? > 0) {
    die "There was a problem decrypting password: $path\n"
  }
  $password =~ s/\n//g;
  chomp $password;
  return $password;
}

sub get_folders {
  my $opts = shift;

  my $imap = Mail::IMAPClient->new(%$opts) or die "Couldn't connect to imap";
  say STDERR "Connected. Getting folder list.";

  my $folders = $imap->folders
    or die "List folders error: ", $imap->LastError, "\n";
  $imap->disconnect;

  return $folders;
}

sub alert {
  system(qw(emacsclient -a '' -e), '(mu4e-update-mail-and-index t)');
  system(qw(emacsclient -a '' -e), '(mu4e-maildirs-extension-force-update)');
}
