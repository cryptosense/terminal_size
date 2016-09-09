#define _GNU_SOURCE

#include <dlfcn.h>
#include <stdlib.h>
#include <stdio.h>
#include <asm-generic/ioctls.h>
#include <asm-generic/termios.h>

typedef int (*ioctl_t)(int, unsigned long, char*);

static ioctl_t real_ioctl = NULL;

int ioctl(int fd, unsigned long request, char* argp)
{
	if (real_ioctl == NULL) {
		real_ioctl = (ioctl_t) dlsym(RTLD_NEXT, "ioctl");
	}
	if (request == TIOCGWINSZ) {
		char* p_rows = getenv("FAKE_ROWS");
		char* p_cols = getenv("FAKE_COLS");
		if (*p_rows == '\0' || *p_cols == '\0') {
			return -1;
		}
		struct winsize *pws = (struct winsize *) argp;
		pws->ws_row = atoi(p_rows);
		pws->ws_col = atoi(p_cols);
		return 0;
	} else {
		return real_ioctl(fd, request, argp);
	}
}
