## Hyper Farm Helper (Global)
1. Add your accounts to the table.
```lua
getgenv().Names={"account", "account 2", "account 3"}
```
2. Place script in auto execution.
3. Join game and it will auto start.

Script: [Click](https://raw.githubusercontent.com/evjkh/HyperHelper/main/GlobalHelper.lua)
## Hyper Farm Helper (Local)
Notes:
- The server must run 24/7 to work
- Enable "Use Local Helpers" on the farmer script.

| Install Methods  |
| ------------- |
| **Automatic Install:**<br>1. Run this command in powershell<br>```iwr -useb https://raw.githubusercontent.com/evjkh/HyperHelper/refs/heads/main/LocalInstaller.ps1 \| iex```<br>2. Open downloads folder and locate `HyperHelper`. Start the server with `run.bat`<br>3. Add your accounts to the table on the script.<br>```getgenv().Names={"account", "account 2", "account 3"}```<br>4. Place script in auto execution.<br>5. Join game and it will auto start.|
| **Manual Install:**<br>1. Download the server & install node.js.<br>2. Make a new directory with the server script in it.<br>3. Install express with npm to the directory.<br>4. Run server with node index.js.<br>5. Add your accounts to the table on the script.<br>```getgenv().Names={"account", "account 2", "account 3"}```<br>6. Place script in auto execution.<br>7. Join game and it will auto start.|

Script: [Click](https://raw.githubusercontent.com/evjkh/HyperHelper/main/LocalHelper.lua)<br>
Server: [Click](https://raw.githubusercontent.com/evjkh/HyperHelper/main/LocalServer.js)
