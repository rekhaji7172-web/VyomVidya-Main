import 'package:flutter/foundation.dart';

@immutable
class Quote {
  const Quote(this.text, this.author);

  final String text;
  final String author;
}

/// Fully offline quote collection — no network call, ever. A quote is
/// picked deterministically from [DateTime.now]'s day-of-year, so every
/// user sees a fresh quote once per calendar day and it stays stable across
/// app restarts on the same day (no `Random()`, which would flicker on
/// every rebuild).
abstract final class DailyQuotes {
  static const List<Quote> _all = [
    Quote('The secret of getting ahead is getting started.', 'Mark Twain'),
    Quote('Success is the sum of small efforts repeated day in and day out.', 'Robert Collier'),
    Quote("Don't watch the clock; do what it does. Keep going.", 'Sam Levenson'),
    Quote('The expert in anything was once a beginner.', 'Helen Hayes'),
    Quote('Discipline is choosing between what you want now and what you want most.', 'Abraham Lincoln'),
    Quote('It always seems impossible until it is done.', 'Nelson Mandela'),
    Quote('You don\u2019t have to be great to start, but you have to start to be great.', 'Zig Ziglar'),
    Quote('Small daily improvements are the key to staggering long-term results.', 'James Clear'),
    Quote('Focus on being productive instead of busy.', 'Tim Ferriss'),
    Quote('The future depends on what you do today.', 'Mahatma Gandhi'),
    Quote('Well done is better than well said.', 'Benjamin Franklin'),
    Quote('Learning never exhausts the mind.', 'Leonardo da Vinci'),
    Quote('Push yourself, because no one else is going to do it for you.', 'Unknown'),
    Quote('Dream big. Start small. Act now.', 'Robin Sharma'),
    Quote('Great things are done by a series of small things brought together.', 'Vincent van Gogh'),
    Quote('The only way to do great work is to love what you do.', 'Steve Jobs'),
    Quote('Believe you can and you\u2019re halfway there.', 'Theodore Roosevelt'),
    Quote('Your future is created by what you do today, not tomorrow.', 'Robert Kiyosaki'),
    Quote('Consistency is what transforms average into excellence.', 'Unknown'),
    Quote('Study while others are sleeping; work while others are loafing.', 'William A. Ward'),
    Quote('An investment in knowledge pays the best interest.', 'Benjamin Franklin'),
    Quote('Do something today that your future self will thank you for.', 'Sean Patrick Flanery'),
    Quote('Progress, not perfection.', 'Unknown'),
    Quote('Every accomplishment starts with the decision to try.', 'John F. Kennedy'),
    Quote('The pain of discipline is far less than the pain of regret.', 'Unknown'),
    Quote('Motivation gets you started. Habit keeps you going.', 'Jim Ryun'),
    Quote('There are no shortcuts to any place worth going.', 'Beverly Sills'),
    Quote('Difficult roads often lead to beautiful destinations.', 'Unknown'),
    Quote('You are capable of more than you know.', 'Unknown'),
    Quote('Stay patient and trust your journey.', 'Unknown'),
  ];

  static Quote forDate(DateTime date) {
    final dayOfYear = int.parse(
      '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
    );
    return _all[dayOfYear % _all.length];
  }

  static Quote get today => forDate(DateTime.now());

  const DailyQuotes._();
}
