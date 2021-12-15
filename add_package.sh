NAME=$2
URL=$1

cd packages

git submodule add  --name "$NAME submmodule" "$URL" "$NAME"

git submodule update --init --recursive

melos bootstrap
