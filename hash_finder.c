// brew install openssl llvm
// /opt/homebrew/opt/llvm/bin/clang -o hash_finder hash_finder.c -I /opt/homebrew/opt/openssl/include -L /opt/homebrew/opt/openssl/lib -lssl -lcrypto -fopenmp

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/sha.h>
#include <pthread.h>
#include <omp.h>

#define NUM_THREADS 8 


typedef struct {
    int thread_id;
    const char *hexPrefix;
} ThreadData;

void generateRandomString(char *str, int length) {
    const char charset[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    for (int i = 0; i < length; i++) {
        str[i] = charset[rand() % (sizeof(charset) - 1)];
    }
    str[length] = '\0';
}

void* findHashWithHexPrefix(void* data) {
    ThreadData* threadData = (ThreadData*)data;
    unsigned char hash[SHA256_DIGEST_LENGTH];
    char randomString[11];  
    int attemptCount = 0;

    while (1) {
        generateRandomString(randomString, 10);
        SHA256((unsigned char *)randomString, strlen(randomString), hash);
        attemptCount++;

        char hexHash[2 * SHA256_DIGEST_LENGTH + 1];
        for (int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
            sprintf(&hexHash[2 * i], "%02x", hash[i]);
        }
        hexHash[2 * SHA256_DIGEST_LENGTH] = '\0';

        if (strncmp(hexHash, threadData->hexPrefix, strlen(threadData->hexPrefix)) == 0) {
            printf("%s (hash: %s) (#%d @ %d).\n", randomString, hexHash, attemptCount, threadData->thread_id);
            return NULL;
        }
    }
}

int main(int argc, char **argv) {
    char *hexPrefix = argv[1];

    pthread_t threads[NUM_THREADS];
    ThreadData threadData[NUM_THREADS];

    for (int i = 0; i < NUM_THREADS; i++) {
        threadData[i].thread_id = i;
        threadData[i].hexPrefix = hexPrefix;
        pthread_create(&threads[i], NULL, findHashWithHexPrefix, (void *)&threadData[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    return 0;
}
