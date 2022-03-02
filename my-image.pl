#!/usr/bin/env perl

use strict;
use warnings;
use Gtk3 -init;
use List::Util qw(min);
use Cairo::GObject; 

our $file = "/home/p-hasan/work/math4310/hw3/out/IMG_1133.JPG";
our $image = Gtk3::Image->new();
our $scrolled = Gtk3::ScrolledWindow->new();
our $event_box  = Gtk3::EventBox->new(); 

sub main {

   my $window = Gtk3::Window->new('toplevel');
   $window->set_title('Image Scaling');
   $window->set_default_size(400, 400);
   $window->signal_connect('delete-event' => sub { Gtk3::main_quit });

   my $grid = Gtk3::Grid->new();
   $window->add($grid);


   $scrolled->set_hexpand(1);
   $scrolled->set_vexpand(1);
   # $grid->attach($scrolled, 1, 1, 1, 1);
   $event_box->add($scrolled); 
   $grid->attach($event_box, 1, 1, 1, 1); 
   $scrolled->add_with_viewport($image);

   $event_box->add_events (['pointer-motion-mask', 'pointer-motion-hint-mask']); 

   $event_box->signal_connect("button-press-event", \&handle_ev_press);

   $event_box->signal_connect('motion-notify-event' =>
                              sub {
                                 my ($widget, $event) = @_;
                                 my ($x, $y) = ($event->x, $event->y); 
                                 print "$x, $y\n"; 

                                 }); 

   my $button = Gtk3::Button->new('Load image');
   $button->signal_connect('clicked' => \&on_button_clicked);
   $grid->attach($button, 1, 2, 1, 1); 

   $window->show_all();
   Gtk3::main(); 
}

sub scale_pixbuf {
   my ($pixbuf, $parent) = @_;
   my $max_w = $parent->get_allocation()->{width};
   my $max_h = $parent->get_allocation()->{height};
   my $pixb_w = $pixbuf->get_width();
   my $pixb_h = $pixbuf->get_height();

   if (($pixb_w > $max_w) || ($pixb_h > $max_h)) {
      my $sc_factor_w = $max_w / $pixb_w;
      my $sc_factor_h = $max_h / $pixb_h;
      my $sc_factor = min $sc_factor_w, $sc_factor_h;
      my $sc_w = int ($pixb_w * $sc_factor);
      my $sc_h = int ($pixb_h * $sc_factor);

      my $scaled = $pixbuf->scale_simple($sc_w, $sc_h, 'GDK_INTERP_HYPER');
      return $scaled; 
   }

   return $pixbuf; 
} 

sub load_image {
   my ($file, $parent) = @_; 
   my $pixbuf = Gtk3::Gdk::Pixbuf->new_from_file($file);
   my $scaled = scale_pixbuf($pixbuf, $parent); 
   return $scaled; 
} 

sub on_button_clicked {
   $image->set_from_pixbuf(load_image($file, $scrolled)); 
}

sub handle_ev_press {
   my $widget = shift;
   my $event = shift;

   print $event->x , " : " ,  $event->y , "\n";

} 



&main(); 
