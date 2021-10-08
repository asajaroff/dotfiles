# Minikube 

## Requisites
* Xcode downloaded from the AppStore

## Intel-based 
Recipe for intel based chips.

## ARM 
* Install hyperkit
```bash
brew install hyperkit

# Force 64 bit intel architecture:
arch -x86_64 brew install hyperkit & minikube start --vm=true


```