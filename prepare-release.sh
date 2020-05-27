git rm --cached ./addons/enjin/sdk/graphql/templates
git rm .gitmodules
rm -rf ./addons/enjin/sdk/graphql/templates/.git
git add ./addons/enjin/sdk/graphql/templates
git commit -m "Integrate templates for release"
