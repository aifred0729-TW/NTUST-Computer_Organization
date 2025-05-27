#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

void do_system(int code, char *cmd) {
    char buf[0x50];
    system(cmd);
}

void login(int client_fd, char *buf) {
    char copied[0x30];
    strcpy(copied, buf);

    if (!strncmp(copied, "secretPassword\n", 15)) do_system(0, "ls -la");
    else write(client_fd, "You have an invalid password!\n", 31);
}

int main() {

    while (1) {

    int server_fd, client_fd;
    struct sockaddr_in addr;
    char buf[0x100] = {0};
    ssize_t nbytes;

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd < 0) {
        perror("socket");
        exit(1);
    }

    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    addr.sin_family = AF_INET;
    addr.sin_port = htons(8787);
    addr.sin_addr.s_addr = INADDR_ANY;
    if (bind(server_fd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        perror("bind");
        close(server_fd);
        exit(1);
    }

    if (listen(server_fd, 1) < 0) {
        perror("listen");
        close(server_fd);
        exit(1);
    }

    printf("[+] Listening on port 8787...\n");

    client_fd = accept(server_fd, NULL, NULL);
    if (client_fd < 0) {
        perror("accept");
        close(server_fd);
        exit(1);
    }

    write(client_fd, "Enter password: ", 16);

    nbytes = read(client_fd, buf, sizeof(buf));
    if (nbytes < 0) {
        perror("read");
        close(client_fd);
        close(server_fd);
        return 1;
    }

    login(client_fd, buf);

    close(client_fd);
    close(server_fd);

    }

    return 0;
}
