git init

rm -rf .vscode
flutter pub get

wait $!

pwd

echo "FETCHING PACKAGES SUBMODULES"
git submodule add  --name flutter_app_ https://github.com/QuantumGray/git_hooks_flutter.git flutter_app
git submodule add  --name dart_server_ https://github.com/QuantumGray/quantumgray-flutter-snippets.git dart_server
git submodule update --init --recursive -j 2

echo "INITIALISING PACKAGES"

cd flutter_app && sh init.sh
cd dart_server && sh init.sh

echo "LINKING DEPENDENCIES"

melos bootstrap

echo "POST INIT COMMIT"
git commit -am "auto-post-init-commit"

echo "DONE!"
