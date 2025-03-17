package libfire;

import com.sun.jna.Callback;
import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.NativeLong;

public class App {

    public interface MyCLibrary extends Library {

        MyCLibrary INSTANCE = Native.load("callback", MyCLibrary.class);

        void function_with_callback(String key, NativeLong val, CallbackHandler callback);
    }

    public interface CallbackHandler extends Callback {

        void invoke(String key, NativeLong val);
    }

    public static void main(String[] args) {
        CallbackHandler callback = (String key, NativeLong val) -> {
            System.out.printf("Call in Java: Key=%s, Val=%d\n", key, val.intValue());
        };

        MyCLibrary.INSTANCE.function_with_callback("123", new NativeLong(456), callback);
    }
}
