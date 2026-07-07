# FoodHome Environment

## Local Toolchain

- Flutter SDK: `/home/iaw/soft/flutter`
- Android SDK: `/home/iaw/soft/android/sdk`
- JDK 21: `/home/iaw/soft/jdk21-local/usr/lib/jvm/java-21-openjdk-amd64`

Use project-local caches when running commands:

```bash
export FLUTTER_HOME="/home/iaw/soft/flutter"
export ANDROID_SDK_ROOT="/home/iaw/soft/android/sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export JAVA_HOME="/home/iaw/soft/jdk21-local/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="$FLUTTER_HOME/bin:$JAVA_HOME/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/build-tools/36.0.0:$PATH"
export PUB_CACHE="$PWD/.pub-cache"
export GRADLE_USER_HOME="$PWD/.gradle"
export NO_PROXY="${NO_PROXY:-localhost,127.0.0.1,::1,10.0.2.2}"
export no_proxy="${no_proxy:-localhost,127.0.0.1,::1,10.0.2.2}"
```

## Secrets

Do not commit:

- Firebase project configuration generated for a real environment.
- OpenAI-compatible provider keys.
- Android signing keys or `key.properties`.
- Local `.env` files.

Use Firebase Secret Manager for AI provider credentials once V0.2 begins.
