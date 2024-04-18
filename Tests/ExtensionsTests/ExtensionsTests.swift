@testable import Extensions
import XCTest

final class TestTimerView: XCTestCase {
 let assert: KeyValuePairs<String, Duration> = [
  "0:00:45": .seconds(45),
  "0:01:00": .seconds(60),
  "0:03:55": .minutes(3) + .seconds(55),
  "0:07:00": .minutes(7),
  "1:00:00": .minutes(60),
  "1:01:00": .minutes(61),
  "1:00:01": .minutes(60) + .seconds(1),
  "1:13:46": .seconds(4426),
  "1:55:09": .hours(1) + .minutes(55) + .seconds(9),
  "4:00:00": .hours(4),
  "23:56:34": .hours(23) + .minutes(56) + .seconds(34),
  "23:59:49": .hours(23) + .minutes(59) + .seconds(49),
  "48:00:03": .days(2) + .seconds(3),
  "50:17:59": .hours(50) + .minutes(17) + .seconds(59),
  "95:59:02": .days(3) + .hours(23) + .minutes(59) + .seconds(2)
 ]

 lazy var durations = assert.map(\.1)

 #if !(os(Linux) || os(Windows))
 var options: XCTMeasureOptions {
  let base = XCTMeasureOptions()
  base.iterationCount = 111
  return base
 }
 #endif

 /// Test duration with the `formatted()` function
 func testDuration() {
  for (label, duration) in assert {
   XCTAssertEqual(label, duration.formatted())
  }
  #if os(Linux) || os(Windows)
  measure {
   for duration in durations {
    _ = duration.formatted()
   }
  }
  #else
  measure(options: options) {
   for duration in durations {
    _ = duration.formatted()
   }
  }
  #endif
 }

 /// Test duration with the `timerView` property
 func testTimerView() {
  for (label, duration) in assert {
   XCTAssertEqual(label, duration.timerView)
  }
  #if os(Linux) || os(Windows)
  measure {
   for duration in durations {
    _ = duration.timerView
   }
  }
  #else
  measure(options: options) {
   for duration in durations {
    _ = duration.timerView
   }
  }
  #endif
 }
}

final class TestLosslessStringDuration: XCTestCase {
 let assert: KeyValuePairs<String, Duration> = [
  "1nanosecond": .nanoseconds(1),
  "1microsecond": .microseconds(1),
  "1millisecond": .milliseconds(1),
  "1second": .nanoseconds(1_000_000_000),
  "1second": .seconds(1),
  "1minute": .minutes(1),
  "1hour": .hours(1),
  "1day": .hours(24),
  "7days": .hours(24 * 7),
  "356days": .days(356)
 ]

 lazy var labels = assert.map(\.0)

 #if !(os(Linux) || os(Windows))
 var options: XCTMeasureOptions {
  let base = XCTMeasureOptions()
  base.iterationCount = 111
  return base
 }
 #endif

 func test() throws {
  for (label, duration) in assert {
   try XCTAssertEqual(duration, XCTUnwrap(Duration(label)))
  }

  #if os(Linux) || os(Windows)
  measure {
   for label in labels {
    _ = Duration(label).unsafelyUnwrapped
   }
  }
  #else
  measure(options: options) {
   for label in labels {
    _ = Duration(label).unsafelyUnwrapped
   }
  }
  #endif
 }
}
