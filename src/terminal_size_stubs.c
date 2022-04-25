#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>

struct dimensions {
    int ok;
    int rows;
    int columns;
};

#ifdef _WIN32
#include <windows.h>

struct dimensions get_dimensions() {
    CONSOLE_SCREEN_BUFFER_INFO info;

    int success = GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &info);

    if (!success) {
        return (struct dimensions) {.ok = 0, .rows = 0, .columns = 0};
    }

    // Inspired from https://stackoverflow.com/questions/6812224/getting-terminal-size-in-c-for-windows.
    return (struct dimensions) {
        .ok = 1,
        .rows = info.srWindow.Bottom - info.srWindow.Top + 1,
        .columns = info.srWindow.Right - info.srWindow.Left + 1,
    };
}
#else
#include <sys/ioctl.h>
#include <unistd.h>

struct dimensions get_dimensions() {
	struct winsize ws;

	int z = ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws);

	if (!z) {
        return (struct dimensions) {.ok = 1, .rows = ws.ws_row, .columns = ws.ws_col};
    }

    return (struct dimensions) {.ok = 0, .rows = 0, .columns = 0};
}
#endif

CAMLprim value ocaml_terminal_size_get(value unit) {
	CAMLparam1(unit);
	CAMLlocal2(result, pair);

    struct dimensions dimensions = get_dimensions();

    if (dimensions.ok) {
		result = caml_alloc(1, 0);
		pair = caml_alloc(2, 0);
		Store_field(result, 0, pair);
		Store_field(pair, 0, Val_int(dimensions.rows));
		Store_field(pair, 1, Val_int(dimensions.columns));
    } else {
        result = Val_int(0);
    }

	CAMLreturn (result);
}
