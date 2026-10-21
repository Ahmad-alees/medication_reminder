/// Injectable clock so domain rules never read the device clock directly.
abstract class Clock {
  DateTime nowUtc();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();
}

class FakeClock implements Clock {
  FakeClock(DateTime nowUtc) : _nowUtc = nowUtc.toUtc();

  DateTime _nowUtc;

  @override
  DateTime nowUtc() => _nowUtc;

  void advance(Duration duration) {
    _nowUtc = _nowUtc.add(duration);
  }

  void setNow(DateTime nowUtc) {
    _nowUtc = nowUtc.toUtc();
  }
}
