import * as url from 'url'
import * as path from 'path'

import {app, BrowserWindow} from 'electron'
import { registryIPC } from './ipc';
const DEBUG = true

export let mainwindow:BrowserWindow;

function createWindow(){
    mainwindow = new BrowserWindow({
        width:1200,
        height:800
    })

    mainwindow.loadFile(path.join(__dirname,"index.html"))
    if(DEBUG) mainwindow.webContents.openDevTools()
    mainwindow.on('close',()=>{
        mainwindow = null
    })
}

app.on('ready',createWindow)

app.on('window-all-closed',()=>{
    if(process.platform !== 'darwin'){
        app.quit()
    }
})

app.on('activate',()=>{
    if(mainwindow === null){
        createWindow()
    }
})

registryIPC()