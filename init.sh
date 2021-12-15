git init

rm -rf .vscode
flutter pub get

wait $!

pwd

echo "FETCHING PACKAGES SUBMODULES"
git submodule add  --name qg_flutter_starter_ https://github.com/QuantumGray/git_hooks_flutter.git qg_flutter_starter
git submodule add  --name qg_server_starter_ https://github.com/QuantumGray/quantumgray-flutter-snippets.git qg_server_starter
git submodule update --init --recursive -j 2

echo "INITIALISING PACKAGES"

cd qg_flutter_starter && sh init.sh
cd qg_server_starter && sh init.sh

echo "LINKING DEPENDENCIES"

melos bootstrap

echo "POST INIT COMMIT"
git commit -am "auto-post-init-commit"

echo "DONE!"
