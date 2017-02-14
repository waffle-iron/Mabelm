package;

import electron.BrowserWindow;
import electron.Electron;

import js.Node;

/**
 *
 */
class Main
{
	/**
	 *
	 */
	public static function main() 
	{
		var app = Electron.app;
		var mainWindow :BrowserWindow;

		function createWindow() {
			mainWindow = new BrowserWindow({width: 1400, height: 900});
			mainWindow.loadURL('file://' + Node.__dirname + '/public/index.html');

			mainWindow.on('closed', function() {
				mainWindow = null;
			});

			mainWindow.webContents.openDevTools();
		}

		if(app != null) {
			app.on('ready', createWindow);

			app.on('activate', function () {
				if (mainWindow == null)
					createWindow();
			});

			app.on('window-all-closed', function () {
				untyped(if (process.platform != 'darwin') app.quit());
			});
		}
			
		Electron.ipcMain.on('compileGame', function(e,a) {
			compileGame(e);
		});
	}

	public static function compileGame(event :Dynamic) : Void
	{
		var exec = untyped(require('child_process').exec);
		var cmd = 'cd development/kha/ && node Kha/make html5 && cd ../..';

		exec(cmd, function(error, stdout, stderr) {
			event.sender.send('compileCompleted', "");
		});

	}
}











