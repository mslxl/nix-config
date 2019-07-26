import { Book, MainBody } from "../book";
import * as fs from 'fs'
import { writeMetaInfContent } from "./meta";
import { writeOebpsContent } from "./oebps";

export function generateEpub(info:Book,text:MainBody[],outDir:string){
    writeMinetype(outDir)
    mkMetaInf(outDir)
    mkOebps(outDir,info,text)
}


function writeMinetype(outDir:string){
    const file = outDir + '/minetype'
    if(!fs.existsSync(file)){
        fs.writeFileSync(file,"application/epub+zip")
    }
}

function mkMetaInf(outDir:string){
    const metaDir = outDir + '/META-INF'
    if(!fs.existsSync(metaDir)){
        fs.mkdirSync(metaDir)
    }
    writeMetaInfContent(metaDir)
}

function mkOebps(outDir:string,info:Book,text:MainBody[]){
    const oebps = outDir + '/OEBPS'
    if(!fs.existsSync(oebps)){
        fs.mkdirSync(oebps)
    }
    writeOebpsContent(oebps,info,text)
}