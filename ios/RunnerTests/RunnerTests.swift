import XCTest
@testable import Runner

final class RunnerTests: XCTestCase {

  func testURLConstruction() {
    let postId = 1
    let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postId)")
    XCTAssertNotNil(url)
    XCTAssertEqual(url?.absoluteString, "https://jsonplaceholder.typicode.com/comments?postId=1")
  }

  func testURLConstructionWithLargePostId() {
    let postId = 99999
    let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postId)")
    XCTAssertNotNil(url)
    XCTAssertTrue(url?.absoluteString.contains("postId=99999") == true)
  }

  func testValidJSONResponseParsing() {
    let jsonString = """
    [{"postId":1,"id":1,"name":"test","email":"test@test.com","body":"body"}]
    """
    let data = jsonString.data(using: .utf8)
    XCTAssertNotNil(data)
    let parsed = String(data: data!, encoding: .utf8)
    XCTAssertEqual(parsed, jsonString)
  }

  func testEmptyResponseData() {
    let data = Data()
    let jsonString = String(data: data, encoding: .utf8)
    XCTAssertEqual(jsonString, "")
  }

  func testInvalidUTF8Response() {
    let invalidBytes: [UInt8] = [0xFF, 0xFE, 0x00, 0x01]
    let data = Data(invalidBytes)
    let jsonString = String(data: data, encoding: .utf8)
    XCTAssertNil(jsonString)
  }

  func testHTTPStatusCodeSuccessRange() {
    let successCodes = [200, 201, 204, 299]
    for code in successCodes {
      XCTAssertTrue((200...299).contains(code), "\(code) should be success")
    }
  }

  func testHTTPStatusCodeErrorRange() {
    let errorCodes = [100, 300, 400, 404, 500, 503]
    for code in errorCodes {
      XCTAssertFalse((200...299).contains(code), "\(code) should be error")
    }
  }
}
