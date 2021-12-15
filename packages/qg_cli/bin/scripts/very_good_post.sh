appname="$1"

dart pub global activate very_good_cli

very_good create "$appname"

cd $appname

git init

rm -rf .vscode
flutter pub get

wait $!

pwd

echo "FETCHING SUBMODULES"
git submodule add  --name hooks_ https://github.com/QuantumGray/git_hooks_flutter.git hooks
# git submodule update --init
git submodule add  --name vscode_ https://github.com/QuantumGray/quantumgray-flutter-snippets.git .vscode
git submodule update --init --recursive -j 2

echo "INITIALISING SUBMODULES"

git config core.hooksPath hooks
chmod ug+x hooks/*

# git pull --recurse-submodules

# echo "UPDATING PUBSPEC.YAML"

echo "POST INIT COMMIT"
git commit -am "auto-post-init-commit"

echo "DONE!"
