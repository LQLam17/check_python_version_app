#include <stdio.h>
#include <stdlib.h>

int main() {
    const char *log_path = "/tmp/python_ver.log";
    printf("Checking Python version on device:\n");

    // Write
    int ret = system("python3 --version > /tmp/python_ver.log 2>&1");
    if (ret == -1 || ret != 0) {
        printf("Error: Python not found\n");
        return 1;
    }

    // Read log
    FILE *f = fopen(log_path, "r");
    if (!f) {
        printf("Error: Cannot read version output\n");
        return 1;
    }

    char version[128] = {0};
    if (fgets(version, sizeof(version), f)) {
        printf("Detected Python Version: %s", version);
    } else {
        printf("Error: Cannot read version output\n");
    }
    fclose(f);

    return 0;
}
