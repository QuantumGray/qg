NAME=$2
URL=$1

cd packages

git submodule add  --name "$NAME submmodule" "$URL" "$NAME"

git submodule update --init --recursive

cd "$NAME"

echo "melos_$NAME.iml" >> .gitignore

git commit -am "refactor: added melos to .gitignore" && git push

melos bootstrap
