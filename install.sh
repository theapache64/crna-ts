echo "Initializing CRNA-TS"

# Getting app name
read -p "Enter app name : " appName

# Insalling CRNA
echo "Creating app..."

yarn global add create-react-native-app && 

# Creating App
create-react-native-app $appName &&

# Changing directory
cd $appName &&

echo "Adding typescript..."

# Adding typescript
yarn add typescript tslint -D && 
yarn add @types/react @types/react-native @types/react-dom -D &&

# We’ll also need rimraf and concurrently to clean the output folder for ts-transpiled-to-js files and concurrently running npm scripts:
yarn add concurrently rimraf -D &&

echo "Adding test modules..."

# For writing Jest unit tests in typescript we will need ts-jest. We’ll also install type defs for Jest and React test renderers:
yarn add ts-jest @types/jest @types/react-test-renderer -D &&

echo "Adding TSLint..."

# TSLint
tsc --init &&

# Downloading TSLint config
wget "https://raw.githubusercontent.com/theapache64/crna-ts/master/tslint.json" &&


# Removing default
rm tsconfig.json

# Adding updated
wget "https://raw.githubusercontent.com/theapache64/crna-ts/master/tsconfig.json" &&

mkdir src build

# Converting .tsx
echo "Converting JS files to TSX"

mv App.js src/App.tsx
mv App.test.js src/App.test.tsx

echo "Adding scripts to package.json"

# Updating package.json new with new scripts
newPackageJson=$(jq '.scripts += {
    "lint": "tslint src/**/*.ts",
    "tsc": "tsc",
    "clean": "rimraf build",
    "build": "yarn run clean && yarn run tsc --",
    "watch": "yarn run build -- -w",
    "watchAndRunAndroid": "concurrently \"yarn run watch\" \"yarn run android\"",
    "buildRunAndroid": "yarn run build && yarn run watchAndRunAndroid",
    "watchAndRunIOS": "concurrently \"yarn run watch\" \"yarn run ios\"",
    "buildRunIOS": "yarn run build && yarn run watchAndRunIOS ",
    "watchAndStart": "concurrently \"yarn run watch\" \"yarn run start\"",
    "buildAndStart": "yarn run build && yarn run watchAndStart"
}' package.json)

# Deleting old package.json
rm package.json &&

# Creating new package.json with new package content
echo $newPackageJson >> package.json &&

# Creating App.js file
echo "import App from './build/App';
export default App;" >> App.js &&

# Finally
yarn install

echo "All done!";
