import Testing
import CObjFW
@testable import ObjFW

@MainActor
@Test func string() async throws {
    
    #if canImport(Darwin)
    let className = "NSObject"
    #else
    let className = "OFObject"  // ObjFW NSString equivalent
    #endif
    
    // 1. Get the NSObject class
    guard let objectClass = objfw_get_class(className) else {
        print("Failed to get NSObject class")
        return
    }
    
    // 2. Manually create instance (equivalent to alloc, but lower-level)
    guard let obj = objfw_create_instance(objectClass, 0) else {
        print("Failed to create instance")
        return
    }
    
    // 3. Prepare selectors
    let initSel = sel_registerName("init")
    let descriptionSel = sel_registerName("description")
    
    // 4. Get IMP for -init
    guard let initIMP = class_getMethodImplementation(objectClass, initSel) else {
        print("Failed to get IMP for init")
        return
    }
    
    // 5. Get IMP for -description
    guard let descIMP = class_getMethodImplementation(objectClass, descriptionSel) else {
        print("Failed to get IMP for description")
        return
    }
    
    // 6. Define the correct function pointer type:
    typealias MethodCall = @convention(c) (objfw_id, objfw_sel) -> objfw_id
    
    let initFunction = unsafeBitCast(initIMP, to: MethodCall.self)
    let descFunction = unsafeBitCast(descIMP, to: MethodCall.self)
    
    // 7. Call [obj init]
    let initializedObj = initFunction(obj as! objfw_id, initSel)
    
    // 8. Call [initializedObj description]
    let descriptionObj = descFunction(initializedObj, descriptionSel)
    
    // 9. Print result
    print(descriptionObj)

}
