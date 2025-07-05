import Testing
import CObjFW
@testable import ObjFW

@MainActor
@Test func string() async throws {
    
    #if canImport(Darwin)
    let className = "NSString"
    #else
    let className = "OFString"
    #endif
    
    // Get OFString class
    let ofStringClass: objfw_class = try #require(objfw_get_class(className))
    
    // Get selectors
    let selStringWithUTF8 = try #require(objfw_register_selector("stringWithUTF8String:"))
    let selUTF8String = try #require(objfw_register_selector("UTF8String"))
    
    // Create the OFString instance
    let swiftStr = "Hello from Swift calling ObjFW C API!"
    let obj = swiftStr.withCString { cString in
        objfw_msgSend_class_id_cstr(ofStringClass, selStringWithUTF8, cString) as objfw_id
    }
    
    let cStr = objfw_msgSend_cstr(obj, selUTF8String) as UnsafePointer<Int8>
    let message = String(cString: cStr)
    print("ObjFW says: \(message)")
}
/*
@_silgen_name("objc_msgSend")
func objfw_msgSend<T>(_ arguments: Any...) -> T

// objfw_id objfw_msgSend_class_id_cstr(objfw_class cls, objfw_sel sel, const char *arg)
@_silgen_name("objc_msgSend")
func objfw_msgSend_class_id_cstr(_ class: objfw_class, _ sel: objfw_sel, _ cString: UnsafePointer<Int8>) -> objfw_id

// const char *objfw_msgSend_cstr(objfw_id obj, objfw_sel sel)
@_silgen_name("objc_msgSend")
func objfw_msgSend_cstr(_ obj: objfw_id, _ sel: objfw_sel) -> UnsafePointer<Int8>
*/
