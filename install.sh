
# Insalling CRNA
yarn global add create-react-native-app && 

# Creating App
mkdirw $1 &&

# Changing directory
cd CRNAExpoTSExample &&

# Adding typescript
yarn add typescript tslint -D && 
yarn add @types/react @types/react-native @types/react-dom -D &&

# We’ll also need rimraf and concurrently to clean the output folder for ts-transpiled-to-js files and concurrently running npm scripts:
yarn add concurrently rimraf -D

# For writing Jest unit tests in typescript we will need ts-jest. We’ll also install type defs for Jest and React test renderers:
yarn add ts-jest @types/jest @types/react-test-renderer -D

# TSLint
tsc --init


