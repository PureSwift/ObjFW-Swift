#ifdef __APPLE__
#include "/opt/homebrew/include/ObjFW/ObjFW.h"
#else
#include "ObjFWRT.h"
#endif

// Types
typedef id objfw_id;
typedef Class objfw_class;
typedef SEL objfw_sel;

// Shims for class and selector handling
static inline objfw_class _Nullable objfw_get_class(const char *name) {
    return objc_getClass(name);
}

static inline objfw_class _Nullable objfw_get_meta_class(const char *name) {
    return objc_getMetaClass(name);
}

static inline objfw_class objfw_allocate_class_pair(objfw_class superclass, const char *name, size_t extraBytes) {
    return objc_allocateClassPair(superclass, name, extraBytes);
}

static inline void objfw_register_class_pair(objfw_class cls) {
    objc_registerClassPair(cls);
}

static inline objfw_sel objfw_register_selector(const char *name) {
    return sel_registerName(name);
}

// Shims for object instantiation
static inline objfw_id objfw_create_instance(objfw_class cls, size_t extraBytes) {
    return class_createInstance(cls, extraBytes);
}

// Shims for adding methods
static inline BOOL objfw_class_add_method(
    objfw_class cls,
    objfw_sel name,
    IMP imp,
    const char *types
) {
    return class_addMethod(cls, name, imp, types);
}
