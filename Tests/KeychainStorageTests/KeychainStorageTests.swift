import XCTest
@testable import KeychainStorage

final class KeychainStorageTests: XCTestCase {
    
    var keychainService: MockKeychainService!
    let key = "key"
    let value = "value"
    
    override func setUp() {
        super.setUp()
        keychainService = MockKeychainService()
        XCTAssertTrue(keychainService.clear(), "")
    }
    
    override func tearDown() {
        XCTAssertTrue(keychainService.clear(), "")
        keychainService = nil
        super.tearDown()
    }
    
    func testSet() {
        let checkData = keychainService.setString(value, forKey: key)
        XCTAssertTrue(checkData, "")
    }
    
    func testGet() {
        XCTAssertTrue(keychainService.setString(value, forKey: key), "")
        XCTAssertEqual(keychainService.getString(key), value, "")
    }
    
    func testDelete() {
        XCTAssertTrue(keychainService.setString(value, forKey: key), "")
        XCTAssertTrue(keychainService.delete(key), "")
        XCTAssertNil(keychainService.getString(key), "")
    }
    
    func testClear() {
        XCTAssertTrue(keychainService.setString(value, forKey: key), "")
        XCTAssertTrue(keychainService.clear(), "")
        XCTAssertNil(keychainService.getString(key), "")
    }
    
    func testAllKeys() {
        XCTAssertTrue(keychainService.setString(value, forKey: key), " ")
        let keys = keychainService.allKeys()
        XCTAssertEqual(keys.count, 1, " ")
        XCTAssertEqual(keys[0], key, "\(key)")
    }
}
