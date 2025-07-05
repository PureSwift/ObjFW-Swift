import Testing
import CObjFW
@testable import ObjFW

@Test func string() async throws {
    
    // Get OFString class
    let ofStringClass = objfw_get_class("NSString")
    
    // Get selectors
    let selStringWithUTF8 = objfw_register_selector("stringWithUTF8String:")
    let selUTF8String = objfw_register_selector("UTF8String")
    
    // Create the OFString instance
    let swiftStr = "Hello from Swift calling ObjFW C API!"
    let obj = swiftStr.withCString { cString in
        objfw_msgSend_class_id_cstr(ofStringClass, selStringWithUTF8, cString)
    }
    
    let cStr = try #require(objfw_msgSend_cstr(obj, selUTF8String))
    let message = String(cString: cStr)
    print("ObjFW says: \(message)")
}
