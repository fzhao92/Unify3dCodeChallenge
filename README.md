# Unify3dCodeChallenge

# Unify3dCodeChallenge

## Installation
run pod install in terminal: will install KeychainSwift and RNCryptor pods used
by project
open xcworkspace project file (not xcode project file)

## Further Considerations
* Since photos could be considered large files and storing large files in keychain
  is not recommended, had to research solutions to workaround this. Based on that
  I encrypted each photo taken and store encrypted version locally, and stored the
  key to decrypt in keychain.
* To make this better, would implement user login to allow account creation utilizing
  keychain to store the user info, then encrypt photos based on the user login,
  instead of a hard coded password.
* please note: did not properly set up remote github, so had to force push entire project
  at the end.
