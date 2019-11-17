import { ipcMain, dialog } from 'electron'
import { mainwindow } from './app'
import {Downloader as loader} from './loader'

let project:loader.Project = null

export function registryIPC() {
    ipcMain.on('file:load',(event,p)=>{
        project = loader.load(p)
        log('succ',`Loaded ${p}`)
    })
}

export function log(level: ('info'|'err'|'succ'|'warn'),msg:string){
    mainwindow.webContents.send('log',level,msg)
}