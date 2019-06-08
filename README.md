
# @jonbrennecke/farrago

farrago \ fə-ˈrä-(ˌ)gō , -ˈrā- \ noun
: a motley assortment of things

## Getting started

`$ npm install react-native-jonbrennecke-farrago --save`

### Mostly automatic installation

`$ react-native link react-native-jonbrennecke-farrago`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-jonbrennecke-farrago` and add `RNJonbrenneckeFarrago.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNJonbrenneckeFarrago.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNJonbrenneckeFarragoPackage;` to the imports at the top of the file
  - Add `new RNJonbrenneckeFarragoPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-jonbrennecke-farrago'
  	project(':react-native-jonbrennecke-farrago').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-jonbrennecke-farrago/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-jonbrennecke-farrago')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNJonbrenneckeFarrago.sln` in `node_modules/react-native-jonbrennecke-farrago/windows/RNJonbrenneckeFarrago.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Jonbrennecke.Farrago.RNJonbrenneckeFarrago;` to the usings at the top of the file
  - Add `new RNJonbrenneckeFarragoPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNJonbrenneckeFarrago from 'react-native-jonbrennecke-farrago';

// TODO: What to do with the module?
RNJonbrenneckeFarrago;
```
  
