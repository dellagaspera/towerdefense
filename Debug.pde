void log(String msg) {
    println("\033[94m[LOG]\033[0m " + msg);
}

void logError(String msg) {
    println("\033[31m[ERR]\033[0m " + msg);
}

void logInfo(String msg) {
    println("\033[33m[INF]\033[0m " + msg);
}
