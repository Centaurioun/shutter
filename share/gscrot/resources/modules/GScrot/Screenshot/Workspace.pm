###################################################
#
#  Copyright (C) Mario Kemper 2008 <mario.kemper@googlemail.com>
#
#  This file is part of GScrot.
#
#  GScrot is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#
#  GScrot is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with GScrot; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###################################################

package GScrot::Screenshot::Workspace;

#modules
#--------------------------------------
use utf8;
use strict;
use GScrot::Screenshot::Main;
our @ISA = qw(GScrot::Screenshot::Main);


#define constants
#--------------------------------------
use constant TRUE  => 1;
use constant FALSE => 0;

#--------------------------------------

sub new {
	my $class = shift;

	#call constructor of super class (gscrot_root, debug_cparam, gettext_object, include_cursor, delay)
	my $self = $class->SUPER::new( shift, shift, shift, shift, shift );
	
	$self->{_selected_workspace} = shift;
	
	bless $self, $class;
	return $self;
}

sub workspace {
	my $self = shift;
	
	my $active_workspace = $self->{_wnck_screen}->get_active_workspace;
	my $wrksp_changed = FALSE;
	foreach my $space ( @{$self->{_workspaces}} ) {
		next unless defined $space;
		if (    $self->{_selected_workspace} == $space->get_number
			 && $self->{_selected_workspace} != $active_workspace->get_number )
		{
			$space->activate( time );
			$wrksp_changed = TRUE;
		}
	}

	#mh...just sleep until workspace is changed (fixme?)
	if ( $self->{_delay} < 2 && $wrksp_changed ) {
		$self->{_delay} = 2;
	}

	my $output =
		$self->get_pixbuf_from_drawable( $self->get_root_and_geometry, $self->{_include_cursor}, $self->{_delay});

	$active_workspace->activate( time ) if $wrksp_changed;
	return $output;
}

1;
