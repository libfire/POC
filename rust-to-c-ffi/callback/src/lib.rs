use std::os::raw::{c_char, c_ulong};

type CallbackFunc = extern "C" fn(*const c_char, c_ulong);

#[no_mangle]
pub extern "C" fn function_with_callback(key: *const c_char, val: c_ulong, callback: CallbackFunc) {
    if callback as usize != 0 && !key.is_null() {
        callback(key, val);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::ffi::CString;

    extern "C" fn callback(key: *const c_char, val: c_ulong) {
        unsafe {
            let key_str = std::ffi::CStr::from_ptr(key).to_string_lossy().into_owned();
            println!("Key: {}, Val: {}", key_str, val);
        }
    }

    #[test]
    fn test_function_with_callback() {
        let key = CString::new("123").expect("Failed to create CString");
        function_with_callback(key.as_ptr(), 456, callback);
    }
}
