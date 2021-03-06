echo "Initializing CRNA-TS"

# Getting app name
read -p "Enter app name : " appName

# Insalling CRNA
echo "Creating app..."

sudo npm install -g add create-react-native-app && 

# Creating App
create-react-native-app $appName &&

# Changing directory
cd $appName &&

echo "Adding typescript..."

# Adding typescript
npm install --save-dev typescript tslint tslint-config-airbnb tslint-react && 

# Adding types
npm install --save-dev @types/react @types/react-native @types/react-dom &&

# We’ll also need rimraf and concurrently to clean the output folder for ts-transpiled-to-js files and concurrently running npm scripts:
npm install --save-dev concurrently rimraf &&

echo "Adding test modules..."

# For writing Jest unit tests in typescript we will need ts-jest. We’ll also install type defs for Jest and React test renderers:
npm install --save-dev ts-jest @types/jest @types/react-test-renderer &&

echo "Adding TSLint..."

# TSLint
tsc --init &&

# Downloading TSLint config
wget "https://raw.githubusercontent.com/theapache64/crna-ts/master/tslint.json" &&


# Removing default ts config
rm tsconfig.json &&

# Adding updated
wget "https://raw.githubusercontent.com/theapache64/crna-ts/master/tsconfig.json" &&

mkdir src build &&

# Converting .tsx
echo "Converting JS files to TSX"

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

# Removing js files

rm App.js &&
rm App.test.js &&


# Create src/App.tsx
curl "https://raw.githubusercontent.com/theapache64/crna-ts/master/App.tsx.txt" >> src/App.tsx &&

# Create src/App.test.tsx
curl "https://raw.githubusercontent.com/theapache64/crna-ts/master/App.test.tsx.txt" >> src/App.test.tsx &&

# Create App.js
curl "https://raw.githubusercontent.com/theapache64/crna-ts/master/App.js.txt" >> App.js &&

# Adding build folder to gitignore
echo "build" >> .gitignore

# Finally
npm install &&

echo "All done!";
