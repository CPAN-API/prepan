package PrePAN::Notify;
use strict;
use warnings;

use PrePAN::Util;
use PrePAN::Email;
use PrePAN::Qudo::Client;

sub notify_comment {
    my ($class, $user, $args) = @_;

    my $review = $args->{review};
    my $module = $args->{module};

    $class->_notify($user, {
        subject_id => $review->is_public ?
            convert_to_short_id($review->user_id) : undef,
        object_id  => $module->short_id,
        verb       => 'comment',
        info       => {
            content => $review->comment,
            created => $review->created.q(),
        },
    });
}

sub notify_vote {
    my ($class, $user, $vote) = @_;

    $class->_notify($user, {
        subject_id => convert_to_short_id $vote->user_id,
        object_id  => convert_to_short_id $vote->module_id,
        verb       => 'vote',
        info       => {
            created => $vote->created.q(),
        },
    });
}

sub _notify {
    my ($class, $user, $entry) = @_;

    my $timeline = $user->timeline;
    $timeline->add($entry);

    $user->update({ unread_count => $user->unread_count + 1 });
}

1;
