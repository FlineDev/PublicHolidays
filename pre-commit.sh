RED="\033[0;31m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m"
RESET="\033[0m"

if ! [ -x "$(command -v brew)" ]; then
  echo "$YELLOW[pre-commit.sh]: Installing Homebrew ...$RESET"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if ! [ -x "$(command -v mint)" ]; then
  echo "$YELLOW[pre-commit.sh]: Installing Mint ...$RESET"
  brew install mint
fi

if ! [ -x "$(command -v swift-format)" ]; then
  echo "$YELLOW[pre-commit.sh]: Installing Swift-Format ...$RESET"
  mint install apple/swift-format
fi

if ! [ -x "$(command -v sourcery)" ]; then
  echo "$YELLOW[pre-commit.sh]: Installing Sourcery ...$RESET"
  brew install sourcery
fi

echo "$YELLOW[pre-commit.sh]: Configuring git pre-commit hook ...$RESET"
mkdir -p .git/hooks
touch .git/hooks/pre-commit

echo "./build-script.sh" > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "$YELLOW[pre-commit.sh]: Configuration was successful! 🎉$RESET"
